using System;
using System.Web.UI;

namespace vivektank1
{
    /// <summary>
    /// Admin Dashboard code-behind.
    /// Shows the admin panel overview: statistics cards and the user list.
    /// Only a signed-in admin (Session["AdminId"]) may open this page.
    /// </summary>
    public partial class AdminDashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Server-side state management: only for a signed-in admin.
            if (Session["AdminId"] == null)
            {
                Response.Redirect("~/Admin/AdminLogin.aspx");
                return;
            }

            // Database phase: fill the statistic cards and the user list table
            // with ADO.NET (SqlConnection / SqlCommand / SqlDataReader) here.
        }
    }
}
