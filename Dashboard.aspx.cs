using System;
using System.Data;
using System.Globalization;
using System.Web.UI;

namespace vivektank1
{
    /// <summary>
    /// Dashboard page code-behind.
    /// Shows the bill overview (summary cards + recent bills).
    /// The bills saved in Bill Entry are kept in Session["SavedBills"] and
    /// bound to the Repeater here; in the database phase the same code reads
    /// from SQL Server with ADO.NET (SqlDataAdapter + DataSet).
    /// </summary>
    public partial class Dashboard : Page
    {
        // Design figures of the Figma layout (older bills of the shop).
        private const decimal BASE_BILLS = 35m;
        private const decimal BASE_TOTAL = 125430m;
        private const decimal BASE_PAID = 98430m;

        protected void Page_Load(object sender, EventArgs e)
        {
            // State management: the dashboard is only for a signed-in user.
            // No Session["UserId"] -> send the visitor to the Login page.
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            // Highlight this page in the sidebar of the master page.
            DashboardMaster shell = (DashboardMaster)Master;
            shell.ActivateNav("Dashboard");

            if (!IsPostBack)
            {
                BindRecentBills();
            }

            ShowSavedToast();
        }

        /// <summary>
        /// Toast message after saving a bill:
        /// Dashboard.aspx?saved=1&amp;bill=BIL-20260930143052-4721
        /// Only the bill number from the query string is shown; the Label
        /// encodes it, so no script can come through.
        /// </summary>
        private void ShowSavedToast()
        {
            if (Request.QueryString["saved"] == "1")
            {
                string billNo = Request.QueryString["bill"];
                if (!string.IsNullOrEmpty(billNo))
                {
                    pnlToast.Visible = true;
                    lblToastMsg.Text = "Bill " + billNo
                        + " is saved and shown in Recent Bills.";
                }
            }
        }

        /// <summary>
        /// Fills the Recent Bills Repeater and the three summary cards.
        /// Top: the bills just saved in Bill Entry (newest first),
        /// below them the design sample rows BIL-201 ... BIL-205.
        /// </summary>
        private void BindRecentBills()
        {
            DataTable bills = RecentTable();

            int newBills = 0;
            decimal newTotal = 0m;
            decimal newPaid = 0m;

            DataTable saved = Session["SavedBills"] as DataTable;
            if (saved != null)
            {
                // Newest bill on top -> walk the Session table backwards.
                for (int i = saved.Rows.Count - 1; i >= 0; i--)
                {
                    DataRow bill = saved.Rows[i];
                    decimal amount = Convert.ToDecimal(bill["Amount"]);
                    string status = Convert.ToString(bill["Status"]);

                    AddRow(bills, bill["BillNo"], bill["BillDate"],
                           bill["Customer"], amount, status);

                    newBills++;
                    newTotal += amount;
                    if (status == "Cash")
                    {
                        newPaid += amount;
                    }
                }
            }

            // Static rows of the design (always shown under the new bills).
            // Status of the design rows uses the same words as Bill Entry:
            // Cash (green) and Pending (orange).
            AddRow(bills, "BIL-201", "16-May-2026", "Rahul Patel", 12850m, "Cash");
            AddRow(bills, "BIL-202", "14-May-2026", "Anjali Gupta", 24000m, "Cash");
            AddRow(bills, "BIL-203", "12-May-2026", "Amit Yadav", 11500m, "Pending");
            AddRow(bills, "BIL-204", "10-May-2026", "Raj Mehta", 15620m, "Pending");
            AddRow(bills, "BIL-205", "09-May-2026", "Pooja Sharma", 34460m, "Pending");

            // Data binding (classic Web Forms way).
            rptRecentBills.DataSource = bills;
            rptRecentBills.DataBind();

            // Summary cards = design figures + bills saved in this session.
            lblTotalBills.Text = (BASE_BILLS + newBills).ToString("N0", EnIn());
            lblTotalAmount.Text = "\u20B9 " + (BASE_TOTAL + newTotal).ToString("N0", EnIn());
            lblPaidAmount.Text = "\u20B9 " + (BASE_PAID + newPaid).ToString("N0", EnIn());

            // ----------------------------------------------------------------
            // Database phase: the same three numbers with ADO.NET, e.g.
            //   SELECT COUNT(*), SUM(GrandTotal) FROM Bills
            //   SELECT SUM(GrandTotal) FROM Bills WHERE PaymentMode = 'Cash'
            // ----------------------------------------------------------------
        }

        /// <summary>Table structure behind the Recent Bills Repeater.</summary>
        private DataTable RecentTable()
        {
            DataTable dt = new DataTable("RecentBills");
            dt.Columns.Add("BillNo", typeof(string));
            dt.Columns.Add("BillDate", typeof(string));
            dt.Columns.Add("Customer", typeof(string));
            dt.Columns.Add("AmountText", typeof(string));
            dt.Columns.Add("Status", typeof(string));
            dt.Columns.Add("BadgeCss", typeof(string));
            return dt;
        }

        /// <summary>One row of the Recent Bills Repeater.</summary>
        private void AddRow(DataTable dt, object billNo, object date,
                            object customer, decimal amount, string status)
        {
            DataRow row = dt.NewRow();
            row["BillNo"] = billNo;
            row["BillDate"] = date;
            row["Customer"] = customer;
            row["AmountText"] = amount.ToString("N0", EnIn());
            row["Status"] = status;
            // Cash -> green Cash badge, Pending -> orange Pending badge.
            row["BadgeCss"] = (status == "Pending") ? "badge-pending" : "badge-cash";
            dt.Rows.Add(row);
        }

        /// <summary>Indian number format: 1,25,430 (lakh grouping).</summary>
        private CultureInfo EnIn()
        {
            return CultureInfo.CreateSpecificCulture("en-IN");
        }
    }
}
