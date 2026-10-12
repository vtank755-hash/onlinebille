using System;
using System.Web.UI;

namespace vivektank1
{
    /// <summary>
    /// Edit Bill code-behind - STATIC page in this stage (the same
    /// approach as the static filters of ViewBills.aspx): the form shows
    /// the design bill exactly as the Figma design, but no editing, no
    /// amount calculation and no saving is performed here.
    /// The page only keeps the signed-in state management and marks the
    /// Bill Entry item of the sidebar as active.
    /// Later stage: read ?bill=... from SQL Server with ADO.NET and
    /// UPDATE the Bills / BillItems tables on the Update Invoice button.
    /// </summary>
    public partial class BillEntryEdit : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // State management: only for a signed-in user.
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            // Edit Bill belongs to the Bill Entry section of the sidebar.
            DashboardMaster shell = (DashboardMaster)Master;
            shell.ActivateNav("BillEntry");
        }
    }
}
