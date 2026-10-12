using System;
using System.Data;
using System.Globalization;
using System.Web.UI;

namespace vivektank1
{
    /// <summary>
    /// Bill Details code-behind (the invoice of one bill).
    /// Opened as BillDetails.aspx?bill=BIL-... from the View buttons.
    /// Bills saved in Bill Entry are read from Session["SavedBills"] and
    /// Session["BillItems"]; the five design bills use their sample items.
    /// Database phase: the same two reads with ADO.NET, e.g.
    ///   SELECT * FROM Bills      WHERE BillNo = @BillNo
    ///   SELECT * FROM BillItems  WHERE BillNo = @BillNo
    /// </summary>
    public partial class BillDetails : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // State management: only for a signed-in user.
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            // Bill Details belongs to the bills section of the sidebar.
            DashboardMaster shell = (DashboardMaster)Master;
            shell.ActivateNav("ViewBills");

            if (!IsPostBack)
            {
                ShowBill();
            }
        }

        /// <summary>Shows the bill named in the address bar (?bill=...).</summary>
        private void ShowBill()
        {
            string billNo = (Request.QueryString["bill"] ?? "").Trim();
            if (billNo.Length == 0)
            {
                ShowNotFound();
                return;
            }

            lblBillNo.Text = billNo;

            // 1) Bills saved in Bill Entry during this session.
            DataTable saved = Session["SavedBills"] as DataTable;
            if (saved != null)
            {
                foreach (DataRow bill in saved.Rows)
                {
                    if (!string.Equals(Convert.ToString(bill["BillNo"]), billNo,
                                       StringComparison.OrdinalIgnoreCase))
                    {
                        continue;
                    }

                    lblDate.Text = Convert.ToString(bill["BillDate"]);
                    lblCustomer.Text = Convert.ToString(bill["Customer"]);
                    lblMobile.Text = bill.Table.Columns.Contains("Mobile")
                        ? Convert.ToString(bill["Mobile"]) : "\u2013";
                    lblAddress.Text = bill.Table.Columns.Contains("Address")
                        ? Convert.ToString(bill["Address"]) : "\u2013";

                    SetStatus(Convert.ToString(bill["Status"]));

                    decimal total = Convert.ToDecimal(bill["Amount"]);

                    // Item rows stored together with the bill.
                    DataTable items = ItemTable();
                    DataTable store = Session["BillItems"] as DataTable;
                    if (store != null)
                    {
                        foreach (DataRow it in store.Rows)
                        {
                            if (string.Equals(Convert.ToString(it["BillNo"]), billNo,
                                              StringComparison.OrdinalIgnoreCase))
                            {
                                AddItemRow(items, it["ItemName"], it["Qty"],
                                           it["Rate"], it["Amount"]);
                            }
                        }
                    }

                    if (items.Rows.Count == 0)
                    {
                        lblNoItems.Visible = true;
                    }

                    BindItems(items, total);
                    return;
                }
            }

            // 2) Design sample bills BIL-201 ... BIL-205.
            if (ShowSample(billNo))
            {
                return;
            }

            ShowNotFound();
        }

        /// <summary>The five sample bills of the design, with their items.</summary>
        private bool ShowSample(string billNo)
        {
            DataTable items = ItemTable();
            decimal total = 0m;

            switch (billNo)
            {
                case "BIL-201":
                    lblDate.Text = "16-May-2026";
                    lblCustomer.Text = "Rahul Patel";
                    lblMobile.Text = "9876543210";
                    lblAddress.Text = "21 Nehru Nagar, Indore, Madhya Pradesh";
                    SetStatus("Cash");
                    total = SampleItem(items, "Dell 24\" IPS Monitor", 1, 11500m)
                          + SampleItem(items, "Wireless Mouse & Keyboard Combo", 1, 1350m);
                    break;

                case "BIL-202":
                    lblDate.Text = "14-May-2026";
                    lblCustomer.Text = "Anjali Gupta";
                    lblMobile.Text = "9825012345";
                    lblAddress.Text = "7 Silver Heights, Bhopal, Madhya Pradesh";
                    SetStatus("Cash");
                    total = SampleItem(items, "HP Laptop 15s", 1, 21500m)
                          + SampleItem(items, "Laptop Bag", 1, 2500m);
                    break;

                case "BIL-203":
                    lblDate.Text = "12-May-2026";
                    lblCustomer.Text = "Amit Yadav";
                    lblMobile.Text = "9701122334";
                    lblAddress.Text = "44 Shanti Villa, Jabalpur, Madhya Pradesh";
                    SetStatus("Pending");
                    total = SampleItem(items, "Canon Printer G2010", 1, 8900m)
                          + SampleItem(items, "Ink Cartridge Set", 1, 2350m)
                          + SampleItem(items, "USB Cable 1m", 1, 250m);
                    break;

                case "BIL-204":
                    lblDate.Text = "10-May-2026";
                    lblCustomer.Text = "Raj Mehta";
                    lblMobile.Text = "9967801234";
                    lblAddress.Text = "12 Gandhi Chowk, Ujjain, Madhya Pradesh";
                    SetStatus("Pending");
                    total = SampleItem(items, "ASUS Monitor 23.8\"", 1, 12999m)
                          + SampleItem(items, "Logitech Keyboard", 1, 1499m)
                          + SampleItem(items, "Optical Mouse", 1, 1122m);
                    break;

                case "BIL-205":
                    lblDate.Text = "09-May-2026";
                    lblCustomer.Text = "Pooja Sharma";
                    lblMobile.Text = "9123456780";
                    lblAddress.Text = "30 Lake View Colony, Bhopal, Madhya Pradesh";
                    SetStatus("Pending");
                    total = SampleItem(items, "Dell Laptop Inspiron", 1, 31000m)
                          + SampleItem(items, "Laptop Sleeve", 1, 960m)
                          + SampleItem(items, "Wireless Mouse", 1, 2500m);
                    break;

                default:
                    return false;
            }

            BindItems(items, total);
            return true;
        }

        // --------------------------------------------------------------------
        // Helpers
        // --------------------------------------------------------------------

        /// <summary>Status and Payment Mode: always "Cash" or "Pending"
        /// (the same word that Bill Entry stores).</summary>
        private void SetStatus(string status)
        {
            string word = (status == "Cash") ? "Cash" : "Pending";
            lblMode.Text = word;
            lblStatus.Text = word;
            lblStatus.CssClass = (word == "Cash") ? "badge badge-cash"
                                                  : "badge badge-pending";
        }

        private void ShowNotFound()
        {
            pnlCard.Visible = false;
            lblNotFound.Visible = true;
        }

        private void BindItems(DataTable items, decimal total)
        {
            rptItems.DataSource = items;
            rptItems.DataBind();

            lblSubtotal.Text = total.ToString("N2", EnIn());
            lblGrandTotal.Text = total.ToString("N2", EnIn());
        }

        /// <summary>Table structure behind the item Repeater.</summary>
        private DataTable ItemTable()
        {
            DataTable dt = new DataTable("BillDetailItems");
            dt.Columns.Add("Sno", typeof(int));
            dt.Columns.Add("ItemName", typeof(string));
            dt.Columns.Add("Qty", typeof(object));
            dt.Columns.Add("RateText", typeof(string));
            dt.Columns.Add("AmountText", typeof(string));
            return dt;
        }

        /// <summary>One item row (values already stored with the bill).</summary>
        private void AddItemRow(DataTable dt, object name, object qty,
                                object rate, object amount)
        {
            DataRow row = dt.NewRow();
            row["Sno"] = dt.Rows.Count + 1;
            row["ItemName"] = Convert.ToString(name);
            row["Qty"] = Convert.ToInt32(qty);

            decimal r = Convert.ToDecimal(rate);
            decimal a = Convert.ToDecimal(amount);

            row["RateText"] = r.ToString("N2", EnIn());
            row["AmountText"] = a.ToString("N2", EnIn());
            dt.Rows.Add(row);
        }

        /// <summary>One sample item row; returns its amount for the total.</summary>
        private decimal SampleItem(DataTable dt, string name, int qty, decimal rate)
        {
            AddItemRow(dt, name, qty, rate, qty * rate);
            return qty * rate;
        }

        /// <summary>Indian number format: 11,500.00 (lakh grouping).</summary>
        private CultureInfo EnIn()
        {
            return CultureInfo.CreateSpecificCulture("en-IN");
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/ViewBills.aspx");
        }
    }
}
