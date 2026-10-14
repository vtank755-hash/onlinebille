using System;
using System.Web.UI;

namespace vivektank1
{
    /// <summary>
    /// Admin Master Page code-behind.
    /// Provides the shell for all admin pages:
    ///  - Admin Login page  -> simple white header layout (magenta accent)
    ///  - Every other admin page -> dark indigo sidebar + white top bar layout
    /// The Logout link clears the admin Session and returns to Admin Login.
    /// </summary>
    public partial class AdminMaster : MasterPage
    {
        /// <summary>
        /// Title shown in the top bar (pages can set their own, e.g. "Manage Users").
        /// </summary>
        public string TopbarTitle
        {
            get { return lblTopbarTitle.Text; }
            set { lblTopbarTitle.Text = value; }
        }

        /// <summary>
        /// Name shown after "Welcome," in the top bar.
        /// </summary>
        public string TopbarUser
        {
            get { return lblTopbarUser.Text; }
            set { lblTopbarUser.Text = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // The Admin Login page keeps the simple header; all other admin
            // pages get the sidebar + top bar dashboard shell.
            bool isLoginPage = (Page is AdminLogin);

            pnlHeader.Visible = isLoginPage;
            pnlSidebar.Visible = !isLoginPage;
            pnlTopbar.Visible = !isLoginPage;

            adminLayout.Attributes["class"] = isLoginPage
                ? "admin-layout admin-layout-plain"
                : "admin-layout admin-layout-sidebar";

            // Sidebar button colours:
            //  - the button of the section you are on -> blue ("clicked" colour)
            //  - every other button                   -> plain, no background
            string current = System.IO.Path.GetFileName(Context.Request.Path);
            bool onDashboard = string.Equals(current, "AdminDashboard.aspx",
                                              StringComparison.OrdinalIgnoreCase);
            bool onActiveUsers = string.Equals(current, "AdminActiveUsers.aspx",
                                               StringComparison.OrdinalIgnoreCase);
            bool onInactiveUsers = string.Equals(current, "AdminInactiveUsers.aspx",
                                                 StringComparison.OrdinalIgnoreCase);
            bool onAllUsers = string.Equals(current, "AdminAllUsers.aspx",
                                            StringComparison.OrdinalIgnoreCase);
            bool onNewUsers = string.Equals(current, "AdminNewUsers.aspx",
                                            StringComparison.OrdinalIgnoreCase);
            bool onUserProfile = string.Equals(current, "AdminUserProfile.aspx",
                                               StringComparison.OrdinalIgnoreCase);
            bool onEditUser = string.Equals(current, "AdminEditUser.aspx",
                                            StringComparison.OrdinalIgnoreCase);

            lnkNavDashboard.Attributes["class"] = "admin-nav-item" + (onDashboard ? " is-active" : "");
            navUsersItem.Attributes["class"] = "admin-nav-item" +
                ((onActiveUsers || onInactiveUsers || onAllUsers || onNewUsers || onUserProfile || onEditUser) ? " is-active" : "");
        }

        protected void lnkNavUsers_Click(object sender, EventArgs e)
        {
            // Server-side state management (no JavaScript): the button that was
            // clicked turns blue, all the other buttons go back to their
            // normal background colour.
            lnkNavDashboard.Attributes["class"] = "admin-nav-item";
            navUsersItem.Attributes["class"] = "admin-nav-item is-active";
        }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            // Server-side state management: remove the signed-in admin and
            // start a fresh session before going back to the admin login page.
            Session.Remove("AdminId");
            Session.Remove("AdminName");
            Session.Remove("AdminRole");
            Session.Abandon();

            Response.Redirect("~/Admin/AdminLogin.aspx");
        }
    }
}
