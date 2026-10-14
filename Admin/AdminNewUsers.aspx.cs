using System;
using System.Web.UI;

namespace vivektank1
{
    /// <summary>
    /// New Users page code-behind.
    /// Opened from the "New Users" card of the Admin Dashboard.
    /// Only a signed-in admin (Session["AdminId"]) may open this page.
    /// </summary>
    public partial class AdminNewUsers : Page
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
            ((AdminMaster)Master).TopbarTitle = "New Users";

            // Database phase: fill the table with ADO.NET
            // (SELECT TOP ... FROM Users ORDER BY RegistrationDate DESC).
        }
    }
}
