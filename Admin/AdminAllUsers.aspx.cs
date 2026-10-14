using System;
using System.Web.UI;

namespace vivektank1
{
    /// <summary>
    /// All Users page code-behind.
    /// Opened from the "Total Users" card of the Admin Dashboard.
    /// Only a signed-in admin (Session["AdminId"]) may open this page.
    /// </summary>
    public partial class AdminAllUsers : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Server-side state management: only for a signed-in admin.
            if (Session["AdminId"] == null)
            {
                Response.Redirect("~/Admin/AdminLogin.aspx");
                return;
            }

            // Top bar shows the title of this page instead of "Admin Dashboard".
            ((AdminMaster)Master).TopbarTitle = "All Users";

            // Database phase: fill the table with ADO.NET
            // (SELECT * FROM Users ORDER BY UserId) from SQL Server.
        }
    }
}
