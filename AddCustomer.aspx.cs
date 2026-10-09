using System;
using System.Data;
using System.Web.UI;

namespace vivektank1
{
    /// <summary>
    /// Add Customer code-behind.
    /// Opened from Bill Entry (the "+" button). The customer id is
    /// auto-generated (CST-1048, CST-1049, ...), the saved customers are
    /// kept in Session["Customers"] and appear in the Bill Entry dropdown;
    /// in the database phase the rows are written to the SQL Server
    /// Customers table with ADO.NET (SqlCommand.ExecuteNonQuery).
    /// </summary>
    public partial class AddCustomer : Page
    {
        // Design figure: the Figma frame shows the next id as CST-1048.
        private const int BASE_ID = 1048;

        protected void Page_Load(object sender, EventArgs e)
        {
            // State management: this page is only for a signed-in user.
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            // Sidebar highlighting + top bar text of the master page.
            DashboardMaster shell = (DashboardMaster)Master;
            shell.ActivateNav("Customers");
            shell.WelcomePrefix = "Active Session:";

            if (!IsPostBack)
            {
                lblCustId.Text = "Auto ID: " + NextId();
            }
        }

        /// <summary>
        /// Next auto id: CST-1048 for the first saved customer,
        /// CST-1049 for the second, ... (like the design frame).
        /// Database phase: SELECT COUNT(*) FROM Customers and add 1.
        /// </summary>
        private string NextId()
        {
            return "CST-" + (BASE_ID + CustomerList.Rows.Count);
        }

        // --------------------------------------------------------------------
        // Customers saved in Session (state management): every customer that
        // is saved here is offered in the Bill Entry customer dropdown.
        // Database phase: replaced by INSERT INTO Customers ... and the
        // dropdown reads with SqlDataAdapter / DataSet.
        // --------------------------------------------------------------------
        private DataTable CustomerList
        {
            get
            {
                DataTable dt = Session["Customers"] as DataTable;
                if (dt == null)
                {
                    dt = new DataTable("Customers");
                    dt.Columns.Add("CustId", typeof(string));
                    dt.Columns.Add("Name", typeof(string));
                    dt.Columns.Add("Mobile", typeof(string));
                    dt.Columns.Add("Address", typeof(string));
                    Session["Customers"] = dt;
                }
                return dt;
            }
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            // Simple state reset: reload the page with a fresh ViewState.
            Response.Redirect("~/AddCustomer.aspx");
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            // Red messages already stopped the client; guard the server too.
            if (!Page.IsValid)
            {
                return;
            }

            DataRow row = CustomerList.NewRow();
            row["CustId"] = NextId();          // id is taken BEFORE the insert
            row["Name"] = txtName.Text.Trim();
            row["Mobile"] = txtMobile.Text.Trim();
            row["Address"] = txtAddress.Text.Trim();
            CustomerList.Rows.Add(row);

            // ----------------------------------------------------------------
            // Database phase (ADO.NET):
            //   INSERT INTO Customers (CustId, Name, Mobile, Address)
            //   VALUES (@CustId, @Name, @Mobile, @Address)
            //   SqlCommand.ExecuteNonQuery()
            // ----------------------------------------------------------------
            // Back to Bill Entry: the new customer is selected in the dropdown.
            Response.Redirect("~/BillEntry.aspx?cust="
                + Server.UrlEncode(txtName.Text.Trim()));
        }
    }
}
