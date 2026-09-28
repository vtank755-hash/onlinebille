using System;

namespace vivektank1
{
    /// <summary>
    /// Home (Index) page code-behind.
    /// The home page is intentionally static: no ADO.NET, no SQL Server,
    /// no authentication, no Session/ViewState usage and no billing logic.
    /// </summary>
    public partial class Index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Static landing page - nothing to process on postback.
        }
    }
}
