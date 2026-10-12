using System;
using System.Data;
using System.Globalization;
using System.Web.UI;

namespace vivektank1
{
    /// <summary>
    /// View Bills code-behind - the list of every bill.
    /// The From Date / To Date fields, the Status (Cash / Pending) options
    /// and the Search Customer box are static UI only: no date filtering,
    /// no status filtering and no name search is performed in this stage.
    /// Database phase: AllBills() is replaced by
    ///   SELECT BillNo, BillDate, Customer, Amount, Status FROM Bills
    /// (SqlDataAdapter).
    /// </summary>
    public partial class ViewBills : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // State management: only for a signed-in user.
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            // View Bills page of the sidebar.
            DashboardMaster shell = (DashboardMaster)Master;
            shell.ActivateNav("ViewBills");

            if (!IsPostBack)
            {
                BindBills();
            }
        }

        /// <summary>Binds every bill. The From Date / To Date fields, the
        /// Status options and the Search Customer box above the table are
        /// static UI in this stage - they do not filter the list.</summary>
        private void BindBills()
        {
            DataTable bills = AllBills();

            rptBills.DataSource = bills;
            rptBills.DataBind();

            // Message + counter of the page.
            lblEmpty.Visible = (bills.Rows.Count == 0);
            lblTotalRecords.Text = "Total Records: " + bills.Rows.Count;
        }

        /// <summary>Every bill: bills saved in Bill Entry first,
        /// then the five design bills.</summary>
        private DataTable AllBills()
        {
            DataTable dt = new DataTable("AllBills");
            dt.Columns.Add("BillNo", typeof(string));
            dt.Columns.Add("BillDate", typeof(string));
            dt.Columns.Add("Customer", typeof(string));
            dt.Columns.Add("AmountText", typeof(string));
            dt.Columns.Add("Status", typeof(string));
            dt.Columns.Add("BadgeCss", typeof(string));

            // 1) Bills saved in Bill Entry during this session.
            DataTable saved = Session["SavedBills"] as DataTable;
            if (saved != null)
            {
                foreach (DataRow bill in saved.Rows)
                {
                    AddRow(dt,
                        Convert.ToString(bill["BillNo"]),
                        Convert.ToString(bill["BillDate"]),
                        Convert.ToString(bill["Customer"]),
                        Convert.ToDecimal(bill["Amount"]),
                        Convert.ToString(bill["Status"]));
                }
            }

            // 2) Design sample bills.
            AddRow(dt, "BIL-201", "16-May-2026", "Rahul Patel", 12850m, "Cash");
            AddRow(dt, "BIL-202", "14-May-2026", "Anjali Gupta", 24000m, "Cash");
            AddRow(dt, "BIL-203", "12-May-2026", "Amit Yadav", 11500m, "Pending");
            AddRow(dt, "BIL-204", "10-May-2026", "Raj Mehta", 15620m, "Pending");
            AddRow(dt, "BIL-205", "09-May-2026", "Pooja Sharma", 34460m, "Pending");

            return dt;
        }

        /// <summary>One row of the list (amount in Indian number format).</summary>
        private void AddRow(DataTable dt, string billNo, string date,
                            string customer, decimal amount, string status)
        {
            DataRow row = dt.NewRow();
            row["BillNo"] = billNo;
            row["BillDate"] = date;
            row["Customer"] = customer;
            row["AmountText"] = amount.ToString("N0", EnIn());
            row["Status"] = status;

            // Status is always Cash or Pending -> same word in the badge.
            row["BadgeCss"] = (status == "Cash") ? "badge-cash" : "badge-pending";
            dt.Rows.Add(row);
        }

        /// <summary>Indian number format: 12,850 (lakh grouping).</summary>
        private CultureInfo EnIn()
        {
            return CultureInfo.CreateSpecificCulture("en-IN");
        }
    }
}
