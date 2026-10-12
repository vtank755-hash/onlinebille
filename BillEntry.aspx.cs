using System;
using System.Data;
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
                // and immediately show his / her mobile number and address.
                string preselect = Request.QueryString["cust"];
                if (!string.IsNullOrEmpty(preselect)
                    && ddlCustomer.Items.FindByValue(preselect) != null)
                {
                    ddlCustomer.SelectedValue = preselect;
                }

                ShowCustomerDetails();

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
                    dt.Columns.Add("Mobile", typeof(string));
                    dt.Columns.Add("Address", typeof(string));
                    dt.Columns.Add("Amount", typeof(decimal));
                    dt.Columns.Add("Status", typeof(string));
                    Session["SavedBills"] = dt;
                }
                return dt;
            }
        }

        // --------------------------------------------------------------------
        // Item rows of the saved bills (Session["BillItems"]): every invoice
        // stores its items so BillDetails.aspx can show the full bill.
        // Database phase: replaced by INSERT INTO BillItems ... and
        //   SELECT * FROM BillItems WHERE BillNo = @BillNo
        // --------------------------------------------------------------------
        private DataTable SavedBillItems
        {
            get
            {
                DataTable dt = Session["BillItems"] as DataTable;
                if (dt == null)
                {
                    dt = new DataTable("BillItems");
                    dt.Columns.Add("BillNo", typeof(string));
                    dt.Columns.Add("ItemName", typeof(string));
                    dt.Columns.Add("Qty", typeof(int));
                    dt.Columns.Add("Rate", typeof(decimal));
                    dt.Columns.Add("Amount", typeof(decimal));
                    Session["BillItems"] = dt;
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

            // Date typed by the user, otherwise today (dd-MMM-yyyy like design).
            string date = txtBillDate.Text.Trim();
            bill["BillDate"] = (date.Length == 0) ? DateTime.Now.ToString("dd-MMM-yyyy") : date;

            bill["Customer"] = (ddlCustomer.SelectedValue.Trim().Length == 0)
                ? "Walk-in Customer"
                : ddlCustomer.SelectedValue;

            // Customer details shown by Bill Details.
            bill["Mobile"] = txtMobile.Text.Trim();
            bill["Address"] = txtAddress.Text.Trim();

            bill["Amount"] = GetGrandTotal();

            // Payment Mode is stored as it is shown: "Cash" or "Pending"
            // -> Dashboard shows the same word in the Status column.
            bill["Status"] = (ddlPaymentMode.SelectedValue == "Cash") ? "Cash" : "Pending";

            SavedBills.Rows.Add(bill);

            // Items of this bill are stored too, so BillDetails.aspx can
            // print the full invoice (name, quantity, rate, amount).
            foreach (DataRow item in BillRows.Rows)
            {
                DataRow ir = SavedBillItems.NewRow();
                ir["BillNo"] = billNo;

                string itemName = Convert.ToString(item["ItemName"]).Trim();
                ir["ItemName"] = (itemName.Length == 0) ? "Item" : itemName;

                int qty = Convert.ToInt32(item["Qty"]);
                decimal rate = Convert.ToDecimal(item["Rate"]);

                ir["Qty"] = qty;
                ir["Rate"] = rate;
                ir["Amount"] = qty * rate;
                SavedBillItems.Rows.Add(ir);
            }
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
        /// <summary>
        /// Customer dropdown changed (AutoPostBack): show the details of the
        /// selected customer in the Mobile Number and Address boxes.
        /// </summary>
        protected void ddlCustomer_SelectedIndexChanged(object sender, EventArgs e)
        {
            CaptureInputs();   // keep the typed item rows before the round trip
            ShowCustomerDetails();
        }

        /// <summary>
        /// Fills Mobile Number and Address of the selected customer:
        /// saved customers come from Session["Customers"], the five design
        /// customers use their sample details.
        /// Database phase: SELECT Mobile, Address FROM Customers WHERE Name = @Name
        /// </summary>
        private void ShowCustomerDetails()
        {
            string name = ddlCustomer.SelectedValue.Trim();

            // "-- Select Customer --" -> clear both boxes.
            if (name.Length == 0)
            {
                txtMobile.Text = "";
                txtAddress.Text = "";
                return;
            }

            // Customers saved on AddCustomer.aspx (state management).
            DataTable saved = Session["Customers"] as DataTable;
            if (saved != null)
            {
                foreach (DataRow row in saved.Rows)
                {
                    if (string.Equals(Convert.ToString(row["Name"]), name,
                                      StringComparison.OrdinalIgnoreCase))
                    {
                        txtMobile.Text = Convert.ToString(row["Mobile"]);
                        txtAddress.Text = Convert.ToString(row["Address"]);
                        return;
                    }
                }
            }

            // Sample details of the five customers of the design.
            switch (name)
            {
                case "Rahul Patel":
                    txtMobile.Text = "9876543210";
                    txtAddress.Text = "21 Nehru Nagar, Indore, Madhya Pradesh";
                    break;
                case "Anjali Gupta":
                    txtMobile.Text = "9825012345";
                    txtAddress.Text = "7 Silver Heights, Bhopal, Madhya Pradesh";
                    break;
                case "Amit Yadav":
                    txtMobile.Text = "9701122334";
                    txtAddress.Text = "44 Shanti Villa, Jabalpur, Madhya Pradesh";
                    break;
                case "Raj Mehta":
                    txtMobile.Text = "9967801234";
                    txtAddress.Text = "12 Gandhi Chowk, Ujjain, Madhya Pradesh";
                    break;
                case "Pooja Sharma":
                    txtMobile.Text = "9123456780";
                    txtAddress.Text = "30 Lake View Colony, Bhopal, Madhya Pradesh";
                    break;
                default:
                    txtMobile.Text = "";
                    txtAddress.Text = "";
                    break;
            }
        }

        protected void btnAddCustomer_Click(object sender, EventArgs e)
        {
            // The "+" button opens the Add Customer page (design flow);
            // the new customer comes back selected in the dropdown.
            Response.Redirect("~/AddCustomer.aspx");
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
