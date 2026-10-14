using System;
using System.Web.UI;

namespace vivektank1
{
    /// <summary>
    /// Profile code-behind - the profile of the signed-in user shown
    /// read only (label + value rows); the "Edit Profile" button opens
    /// the EditProfile.aspx page (design flow). STATIC in this stage:
    /// nothing is saved here. The page only keeps the signed-in state
    /// management and marks the Profile item of the sidebar as active.
    /// Database phase: fill the labels from the Users table with ADO.NET
    ///   SELECT FullName, Email, Phone FROM Users WHERE Email = @Email
    /// </summary>
    public partial class Profile : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // State management: only for a signed-in user.
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            // Profile page of the sidebar.
            DashboardMaster shell = (DashboardMaster)Master;
            shell.ActivateNav("Profile");

            if (!IsPostBack)
            {
                // Values saved by the Edit Profile page (state management);
                // the design values are shown until they are changed.
                lblName.Text = CurrentName();
                lblFullName.Text = CurrentName();
                lblEmail.Text = CurrentEmail();
                lblPhone.Text = CurrentPhone();
            }
        }

        // --------------------------------------------------------------------
        // Current values of the profile (design values until they are saved)
        // --------------------------------------------------------------------
        private string CurrentName()
        {
            string value = Session["ProfileName"] as string;
            return (value == null || value.Trim().Length == 0) ? "Amit Kumar" : value;
        }

        private string CurrentEmail()
        {
            string value = Session["ProfileEmail"] as string;
            return (value == null || value.Trim().Length == 0) ? "vtank755@rku.ac.in" : value;
        }

        private string CurrentPhone()
        {
            string value = Session["ProfilePhone"] as string;
            return (value == null || value.Trim().Length == 0) ? "96248894623" : value;
        }
    }
}