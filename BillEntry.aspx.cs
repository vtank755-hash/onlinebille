using System;
using System.Data;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace vivektank1
{
    /// <summary>
    /// Bill Entry code-behind.
    /// The item rows are kept in a DataTable inside ViewState (state
    /// management) and rendered with a Repeater. The finished invoice is
    /// stored in Session["SavedBills"] so Dashboard.aspx shows it in
    /// Recent Bills; saving into the SQL Server Bills table with ADO.NET
    /// is added in the database phase.
    /// </summary>
    public partial class BillEntry : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // State management: bill entry is only for a signed-in user.
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            // Sidebar highlighting + top bar text of the master page.
            DashboardMaster shell = (DashboardMaster)Master;
            shell.ActivateNav("BillEntry");
            shell.WelcomePrefix = "Active Session:";

            if (!IsPostBack)
            {
                // Auto-generated bill number, shown in the read-only box.
                txtBillNumber.Text = GenerateBillNo();

                // First row matches the design: qty 1, rate 1500 -> 1,500.00
                DataRow row = BillRows.NewRow();
                row["Id"] = 1;
                row["ItemName"] = "";
                row["Qty"] = 1;
                row["Rate"] = 1500m;
                BillRows.Rows.Add(row);

                // Customers saved on AddCustomer.aspx appear in the dropdown.
                DataTable extra = Session["Customers"] as DataTable;
                if (extra != null)
                {
                    foreach (DataRow cust in extra.Rows)
                    {
                        string name = Convert.ToString(cust["Name"]);
                        if (name.Length > 0 && ddlCustomer.Items.FindByValue(name) == null)
                        {
                            ddlCustomer.Items.Add(new ListItem(name, name));
                        }
                    }
                }

                // Coming back from Add Customer: preselect the new customer
                // and show his details in the Mobile / Address boxes.
                string preselect = Request.QueryString["cust"];
                if (!string.IsNullOrEmpty(preselect)
                    && ddlCustomer.Items.FindByValue(preselect) != null)
                {
                    ddlCustomer.SelectedValue = preselect;
                    FillCustomerDetails(ddlCustomer.SelectedValue.Trim());
                }

                BindItems();
            }
        }

        /// <summary>
        /// Auto-generated bill number, e.g. BIL-20260930143052-4721:
        ///   yyyyMMddHHmmss  = year, month, day, hour, minute, second
        ///   4 random digits = last part of the number
        /// The same number is never reused inside this session.
        /// Database phase: SELECT MAX(BillNo) FROM Bills and add 1.
        /// </summary>
        private string GenerateBillNo()
        {
            string stamp = DateTime.Now.ToString("yyyyMMddHHmmss");
            Random rnd = new Random();
            string billNo;

            do
            {
                billNo = "BIL-" + stamp + "-" + rnd.Next(0, 10000).ToString("D4");
            }
            while (BillNoExists(billNo));

            return billNo;
        }

        /// <summary>True when the number is already used by a saved bill.</summary>
        private bool BillNoExists(string billNo)
        {
            DataTable saved = Session["SavedBills"] as DataTable;
            if (saved == null)
            {
                return false;
            }

            foreach (DataRow row in saved.Rows)
            {
                if (string.Equals(Convert.ToString(row["BillNo"]), billNo,
                                   StringComparison.OrdinalIgnoreCase))
                {
                    return true;
                }
            }
            return false;
        }

        // --------------------------------------------------------------------
        // Saved bills kept in Session (state management): every invoice that
        // is saved here is displayed by Dashboard.aspx.
        // Database phase: this table is replaced by INSERT INTO Bills ... and
        // the dashboard reads with SqlDataAdapter / DataSet.
        // --------------------------------------------------------------------
        private DataTable SavedBills
        {
            get
            {
                DataTable dt = Session["SavedBills"] as DataTable;
                if (dt == null)
                {
                    dt = new DataTable("SavedBills");
                    dt.Columns.Add("BillNo", typeof(string));
                    dt.Columns.Add("BillDate", typeof(string));
                    dt.Columns.Add("Customer", typeof(string));
                    dt.Columns.Add("Amount", typeof(decimal));
                    dt.Columns.Add("Status", typeof(string));
                    Session["SavedBills"] = dt;
                }
                return dt;
            }
        }

        /// <summary>
        /// Grand total of the bill = sum of (Qty x Rate) over all item rows.
        /// </summary>
        private decimal GetGrandTotal()
        {
            decimal total = 0m;
            foreach (DataRow row in BillRows.Rows)
            {
                total += Convert.ToInt32(row["Qty"]) * Convert.ToDecimal(row["Rate"]);
            }
            return total;
        }

        /// <summary>
        /// Stores the finished invoice in Session["SavedBills"] so that the
        /// Dashboard can show it in the Recent Bills table right after the
        /// redirect.
        /// </summary>
        private void SaveBillToSession()
        {
            DataRow bill = SavedBills.NewRow();

            // Bill number generated when the page loaded (never empty).
            string billNo = txtBillNumber.Text.Trim();
            if (billNo.Length == 0)
            {
                billNo = GenerateBillNo();
            }
            bill["BillNo"] = billNo;

            // Date picked from the calendar / typed by the user, otherwise
            // today - always stored as DD-MMM-YYYY (design format).
            bill["BillDate"] = NormalizeBillDate(txtBillDate.Text.Trim());

            bill["Customer"] = (ddlCustomer.SelectedValue.Trim().Length == 0)
                ? "Walk-in Customer"
                : ddlCustomer.SelectedValue;

            bill["Amount"] = GetGrandTotal();

            // Payment Mode is stored as it is shown: "Cash" or "Pending"
            // -> Dashboard shows the same word in the Status column.
            bill["Status"] = (ddlPaymentMode.SelectedValue == "Cash") ? "Cash" : "Pending";

            SavedBills.Rows.Add(bill);
        }

        /// <summary>
        /// Fired when Quantity or Rate is changed (AutoPostBack).
        /// Recalculates Amount = Qty x Rate for the row and the Grand Total.
        /// </summary>
        protected void ItemField_Changed(object sender, EventArgs e)
        {
            CaptureInputs();   // read the typed values into ViewState
            BindItems();       // re-render: amount cells + Grand Total update
        }

        // --------------------------------------------------------------------
        // Bill item rows kept in ViewState (survives every postback)
        // --------------------------------------------------------------------
        private DataTable BillRows
        {
            get
            {
                DataTable dt = ViewState["BillItems"] as DataTable;
                if (dt == null)
                {
                    dt = new DataTable("BillItems");
                    dt.Columns.Add("Id", typeof(int));
                    dt.Columns.Add("ItemName", typeof(string));
                    dt.Columns.Add("Qty", typeof(int));
                    dt.Columns.Add("Rate", typeof(decimal));
                    ViewState["BillItems"] = dt;
                }
                return dt;
            }
        }

        private void BindItems()
        {
            rptItems.DataSource = BillRows;
            rptItems.DataBind();
            UpdateTotal();
        }

        /// <summary>
        /// Copies what the user typed in the row text boxes back into the
        /// ViewState DataTable (always called before the table changes).
        /// </summary>
        private void CaptureInputs()
        {
            for (int i = 0; i < rptItems.Items.Count && i < BillRows.Rows.Count; i++)
            {
                TextBox txtName = (TextBox)rptItems.Items[i].FindControl("txtItemName");
                TextBox txtQty = (TextBox)rptItems.Items[i].FindControl("txtQty");
                TextBox txtRate = (TextBox)rptItems.Items[i].FindControl("txtRate");

                DataRow row = BillRows.Rows[i];
                row["ItemName"] = txtName.Text.Trim();

                int qty;
                row["Qty"] = (int.TryParse(txtQty.Text.Trim(), out qty) && qty > 0) ? qty : 1;

                decimal rate;
                row["Rate"] = (decimal.TryParse(txtRate.Text.Trim(), out rate) && rate >= 0) ? rate : 0m;
            }
        }

        private void UpdateTotal()
        {
            lblGrandTotal.Text = "\u20B9 " + GetGrandTotal().ToString("N2");
        }

        /// <summary>Amount of one row, e.g. "₹ 1,500.00".</summary>
        protected string FormatAmount(object qty, object rate)
        {
            int q = 0;
            decimal r = 0m;
            int.TryParse(Convert.ToString(qty), out q);
            decimal.TryParse(Convert.ToString(rate), out r);
            return "\u20B9 " + (q * r).ToString("N2");
        }

        // --------------------------------------------------------------------
        // Buttons
        // --------------------------------------------------------------------
        protected void btnAddCustomer_Click(object sender, EventArgs e)
        {
            // The "+" button opens the Add Customer page (design flow);
            // the new customer comes back selected in the dropdown.
            Response.Redirect("~/AddCustomer.aspx");
        }

        /// <summary>
        /// A customer was selected in the dropdown: show his details
        /// (Mobile Number + Billing Address) in the two text boxes.
        /// </summary>
        protected void ddlCustomer_SelectedIndexChanged(object sender, EventArgs e)
        {
            FillCustomerDetails(ddlCustomer.SelectedValue.Trim());
        }

        /// <summary>
        /// Fills Mobile Number and Address for the selected customer:
        ///   1) customers saved on AddCustomer.aspx (Session["Customers"]),
        ///   2) the sample customers of the design.
        /// Nothing selected -> both boxes are cleared.
        /// Database phase: SELECT Mobile, Address FROM Customers WHERE Name=@Name
        /// </summary>
        private void FillCustomerDetails(string customerName)
        {
            if (customerName.Length == 0)
            {
                txtMobile.Text = "";
                txtAddress.Text = "";
                txtBillDate.Text = "";
                return;
            }

            // Bill date of the customer is fetched INTO the Bill Date field
            // together with Mobile / Address. The date field is a native
            // date input, so DD-MMM-YYYY -> YYYY-MM-DD (no bill -> empty,
            // and an empty date falls back to today when saving).
            txtBillDate.Text = ToDateInput(LastBillDate(customerName));

            // 1) customers saved on Add Customer (Session state)
            DataTable saved = Session["Customers"] as DataTable;
            if (saved != null)
            {
                foreach (DataRow row in saved.Rows)
                {
                    if (string.Equals(Convert.ToString(row["Name"]), customerName,
                                       StringComparison.OrdinalIgnoreCase))
                    {
                        txtMobile.Text = Convert.ToString(row["Mobile"]);
                        txtAddress.Text = Convert.ToString(row["Address"]);
                        return;
                    }
                }
            }

            // 2) sample customers of the Figma design
            switch (customerName)
            {
                case "Rahul Patel":
                    txtMobile.Text = "9876543210";
                    txtAddress.Text = "24, MG Road, Indore";
                    break;
                case "Anjali Gupta":
                    txtMobile.Text = "9825012345";
                    txtAddress.Text = "7, Lake View, Bhopal";
                    break;
                case "Amit Yadav":
                    txtMobile.Text = "9765432109";
                    txtAddress.Text = "15, Station Road, Jabalpur";
                    break;
                case "Raj Mehta":
                    txtMobile.Text = "9911223344";
                    txtAddress.Text = "3, Nehru Nagar, Ujjain";
                    break;
                case "Pooja Sharma":
                    txtMobile.Text = "9798765432";
                    txtAddress.Text = "88, Vijay Nagar, Gwalior";
                    break;
                default:
                    txtMobile.Text = "";
                    txtAddress.Text = "";
                    break;
            }
        }

        /// <summary>
        /// Bill date of the selected customer (fetched into the Bill Date
        /// field):
        ///   1) bills saved in this session (newest first),
        ///   2) the sample bill date of the design customers,
        ///   3) empty when the customer does not have a bill yet.
        /// Database phase: SELECT MAX(BillDate) FROM Bills WHERE Customer=@name
        /// </summary>
        private string LastBillDate(string customerName)
        {
            DataTable bills = Session["SavedBills"] as DataTable;
            if (bills != null)
            {
                // Newest bill first (rows are appended on save).
                for (int i = bills.Rows.Count - 1; i >= 0; i--)
                {
                    if (string.Equals(Convert.ToString(bills.Rows[i]["Customer"]),
                                       customerName,
                                       StringComparison.OrdinalIgnoreCase))
                    {
                        return Convert.ToString(bills.Rows[i]["BillDate"]);
                    }
                }
            }

            switch (customerName)
            {
                case "Rahul Patel":   return "16-May-2026";
                case "Anjali Gupta":  return "14-May-2026";
                case "Amit Yadav":    return "12-May-2026";
                case "Raj Mehta":     return "10-May-2026";
                case "Pooja Sharma":  return "09-May-2026";
            }
            return "";          // the customer does not have a bill yet
        }

        /// <summary>
        /// Converts the stored DD-MMM-YYYY date ("16-May-2026") to the
        /// YYYY-MM-DD value ("2026-05-16") that the native date field
        /// (TextMode="Date") understands. Empty input or an unknown
        /// format -> empty string.
        /// </summary>
        private string ToDateInput(string date)
        {
            DateTime parsed;
            if (DateTime.TryParseExact(date, "dd-MMM-yyyy",
                    CultureInfo.InvariantCulture, DateTimeStyles.None,
                    out parsed))
            {
                return parsed.ToString("yyyy-MM-dd",
                                       CultureInfo.InvariantCulture);
            }
            return "";
        }

        /// <summary>
        /// The bill date is stored as DD-MMM-YYYY (like the design rows):
        /// the native date picker posts YYYY-MM-DD, typing DD-MM-YYYY also
        /// works, empty -> today. Anything else is kept as typed.
        /// </summary>
        private string NormalizeBillDate(string date)
        {
            if (date.Length == 0)
            {
                return DateTime.Now.ToString("dd-MMM-yyyy",
                                              CultureInfo.InvariantCulture);
            }

            string[] formats = { "yyyy-MM-dd", "dd-MM-yyyy", "d-M-yyyy",
                                 "dd/MM/yyyy", "d/M/yyyy", "dd-MMM-yyyy" };
            DateTime parsed;
            if (DateTime.TryParseExact(date, formats,
                    CultureInfo.InvariantCulture,
                    DateTimeStyles.None, out parsed))
            {
                return parsed.ToString("dd-MMM-yyyy",
                                        CultureInfo.InvariantCulture);
            }
            return date;
        }

        protected void btnAddItem_Click(object sender, EventArgs e)
        {
            CaptureInputs();

            DataRow row = BillRows.NewRow();
            row["Id"] = BillRows.Rows.Count == 0
                ? 1
                : Convert.ToInt32(BillRows.Compute("MAX(Id)", "")) + 1;
            row["ItemName"] = "";
            row["Qty"] = 1;
            row["Rate"] = 0m;
            BillRows.Rows.Add(row);

            BindItems();
        }

        protected void btnDeleteRow_Click(object sender, EventArgs e)
        {
            CaptureInputs();

            int index = ((RepeaterItem)((Control)sender).NamingContainer).ItemIndex;
            if (index >= 0 && index < BillRows.Rows.Count)
            {
                BillRows.Rows.RemoveAt(index);
            }

            if (BillRows.Rows.Count == 0)
            {
                DataRow row = BillRows.NewRow();
                row["Id"] = 1;
                row["ItemName"] = "";
                row["Qty"] = 1;
                row["Rate"] = 0m;
                BillRows.Rows.Add(row);
            }

            BindItems();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            // Simple state reset: reload the page with a fresh ViewState.
            Response.Redirect("~/BillEntry.aspx");
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            // No validation controls and no message box on this page: the
            // invoice is accepted and the user goes back to the dashboard.
            CaptureInputs();
            UpdateTotal();

            // State management: the bill is stored in Session["SavedBills"]
            // so Dashboard.aspx can show it in Recent Bills after the redirect.
            SaveBillToSession();

            // ----------------------------------------------------------------
            // Next step (database phase): ADO.NET disconnected model
            //   INSERT INTO Bills (BillNo, BillDate, Customer, Mobile,
            //                      Address, PaymentMode, GrandTotal)
            //   INSERT INTO BillItems (BillNo, ItemName, Qty, Rate, Amount)
            //   SqlDataAdapter / DataSet or SqlCommand.ExecuteNonQuery
            // ----------------------------------------------------------------
            // The Dashboard reads ?saved=1&bill=... and shows the toast
            // message with the new bill number.
            Response.Redirect("~/Dashboard.aspx?saved=1&bill="
                + Server.UrlEncode(txtBillNumber.Text.Trim()));
        }
    }
}
