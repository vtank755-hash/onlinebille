using System;
using System.Web.UI;

namespace vivektank1
{
    /// <summary>
    /// Edit User page code-behind.
    /// Opened from the edit (pencil) button of the admin user list pages.
    /// STATIC design page: "Update User" does not save anything yet.
    /// Only a signed-in admin (Session["AdminId"]) may open this page.
    /// </summary>
    public partial class AdminEditUser : Page
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
            ((AdminMaster)Master).TopbarTitle = "Edit User";

            // "Cancel" returns to the user list page the admin came from.
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
                    lnkCancel.HRef = file;
                }
            }

            // Database phase: read ?id=USR-001, fill the fields with ADO.NET
            // and make "Update User" run an UPDATE on the Users table.
        }
    }
}
