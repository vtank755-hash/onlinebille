using System;
using System.Web.UI;

namespace vivektank1
{
    /// <summary>
    /// Dashboard shell (sidebar + top bar) code-behind.
    /// Shows the signed-in user name from Session state and handles Logout
    /// (Session.Abandon clears the server-side session).
    /// </summary>
    public partial class DashboardMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Server-side state management: show the name stored at login.
            // Until the database phase, "Amit Kumar" is the design default.
            string name = "Amit Kumar";

            if (Session["UserName"] != null)
            {
                string sessionName = Session["UserName"].ToString().Trim();
                if (sessionName.Length > 0)
                {
                    name = sessionName;
                }
            }

            lblSideName.Text = name;
            lblWelcomeName.Text = name;
        }

        /// <summary>
        /// Text shown before the user name in the top bar.
        /// Pages change it, e.g. BillEntry.aspx uses "Active Session:".
        /// </summary>
        public string WelcomePrefix
        {
            get { return lblWelcomePrefix.Text; }
            set { lblWelcomePrefix.Text = value; }
        }

        /// <summary>
        /// Marks one sidebar item as the active page.
        /// Called by every content page (Dashboard, Bill Entry, ...).
        /// </summary>
        public void ActivateNav(string navKey)
        {
            navDashboard.CssClass = "dash-nav-item";
            navBillEntry.CssClass = "dash-nav-item";
            navCustomers.CssClass = "dash-nav-item";
            navViewBills.CssClass = "dash-nav-item";
            navProfile.CssClass = "dash-nav-item";

            switch (navKey)
            {
                case "BillEntry":
                    navBillEntry.CssClass = "dash-nav-item is-active";
                    break;
                case "Customers":
                    navCustomers.CssClass = "dash-nav-item is-active";
                    break;
                case "ViewBills":
                    navViewBills.CssClass = "dash-nav-item is-active";
                    break;
                case "Profile":
                    navProfile.CssClass = "dash-nav-item is-active";
                    break;
                default:
                    navDashboard.CssClass = "dash-nav-item is-active";
                    break;
            }
        }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            // State management: end the session and go back to the login page.
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }
    }
}
