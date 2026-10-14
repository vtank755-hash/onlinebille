using System;
using System.Web.UI;

namespace vivektank1
{
    /// <summary>
    /// User Profile page code-behind.
    /// Opened from the view (eye) button of the admin user list pages.
    /// Only a signed-in admin (Session["AdminId"]) may open this page.
    /// </summary>
    public partial class AdminUserProfile : Page
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
            ((AdminMaster)Master).TopbarTitle = "User Profile";

            // "back" returns to the user list page the admin came from
            // (All Users / Active Users / Inactive Users / New Users).
            Uri from = Request.UrlReferrer;
            if (from != null)
            {
                string file = System.IO.Path.GetFileName(from.AbsolutePath);
                string[] listPages = 
                { 
                    "AdminDashboard.aspx",
                    "AdminAllUsers.aspx", 
                    "AdminActiveUsers.aspx", 
                    "AdminInactiveUsers.aspx", 
                    "AdminNewUsers.aspx" 
                };

                if (Array.Exists(listPages, delegate(string p)
                    { return p.Equals(file, StringComparison.OrdinalIgnoreCase); }))
                {
                    lnkBack.HRef = file;
                }
            }

            // Database phase: read the ?id=USR-001 query string and fill the
            // fields above with ADO.NET from the Users table in SQL Server.
        }
    }
}
