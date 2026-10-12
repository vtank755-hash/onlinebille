<%@ Page Title="Edit Bill" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="BillEntryEdit.aspx.cs" Inherits="vivektank1.BillEntryEdit" %>

<%-- Edit Bill - STATIC page in this stage (same approach as the static
     filters of ViewBills.aspx): the form shows the bill exactly as the
     Figma design (Customer, Mobile, Address, Bill Date, Bill Number,
     Payment Mode, the item rows and the Grand Total), but no editing,
     no amount calculation and no saving is performed here.
     The Edit buttons of the Dashboard and the View Bills list open
     this page. Later stage: load ?bill=... with ADO.NET and update the
     Bills / BillItems tables of SQL Server. --%>
<asp:Content ID="BillEntryEditContent" ContentPlaceHolderID="DashHeaderTitle" runat="server">Edit Bill</asp:Content>

<asp:Content ID="BillEntryEditBody" ContentPlaceHolderID="DashContent" runat="server">

    <div class="panel entry-panel">

        <h2 class="panel-title entry-title">Update Customer &amp; Invoice Details</h2>

        <div class="form-grid">

            <%-- ---------------------------- CUSTOMER --------------------------- --%>
            <div class="form-group">
                <asp:Label ID="lblCustomer" runat="server"
                    AssociatedControlID="ddlCustomer"
                    CssClass="form-label"
                    Text="Customer Name"></asp:Label>

                <div class="customer-pick">
                    <%-- Static value of the design (no AutoPostBack, no handler). --%>
                    <asp:DropDownList ID="ddlCustomer" runat="server"
                        CssClass="form-control form-select">
                        <asp:ListItem Value="" Text="-- Select Customer --" />
                        <asp:ListItem Value="Rahul Patel" Text="Rahul Patel" Selected="True" />
                        <asp:ListItem Value="Anjali Gupta" Text="Anjali Gupta" />
                        <asp:ListItem Value="Amit Yadav" Text="Amit Yadav" />
                        <asp:ListItem Value="Raj Mehta" Text="Raj Mehta" />
                        <asp:ListItem Value="Pooja Sharma" Text="Pooja Sharma" />
                    </asp:DropDownList>

                    <%-- Static "+" button of the design (no handler yet). --%>
                    <button type="button" class="btn-plus">+</button>
                </div>
            </div>

            <%-- ----------------------------- MOBILE ---------------------------- --%>
            <div class="form-group">
                <asp:Label ID="lblMobile" runat="server"
                    AssociatedControlID="txtMobile"
                    CssClass="form-label"
                    Text="Mobile Number"></asp:Label>

                <asp:TextBox ID="txtMobile" runat="server"
                    CssClass="form-control"
                    Text="9876543210"
                    MaxLength="10"></asp:TextBox>
            </div>

            <%-- ----------------------------- ADDRESS --------------------------- --%>
            <div class="form-group">
                <asp:Label ID="lblAddress" runat="server"
                    AssociatedControlID="txtAddress"
                    CssClass="form-label"
                    Text="Address"></asp:Label>

                <asp:TextBox ID="txtAddress" runat="server"
                    CssClass="form-control"
                    Text="21 Nehru Nagar, Indore, Madhya Pradesh"></asp:TextBox>
            </div>

            <%-- ---------------------------- BILL DATE -------------------------- --%>
            <div class="form-group">
                <asp:Label ID="lblBillDate" runat="server"
                    AssociatedControlID="txtBillDate"
                    CssClass="form-label"
                    Text="Bill Date"></asp:Label>

                <asp:TextBox ID="txtBillDate" runat="server"
                    CssClass="form-control"
                    Text="16-May-2026"></asp:TextBox>
            </div>

            <%-- --------------------------- BILL NUMBER ------------------------- --%>
            <div class="form-group">
                <asp:Label ID="lblBillNumber" runat="server"
                    AssociatedControlID="txtBillNumber"
                    CssClass="form-label"
                    Text="Bill Number"></asp:Label>

                <%-- Read only - the bill number of the design. --%>
                <asp:TextBox ID="txtBillNumber" runat="server"
                    CssClass="form-control"
                    ReadOnly="true"
                    Text="BIL-201"></asp:TextBox>
            </div>

            <%-- -------------------------- PAYMENT MODE ------------------------- --%>
            <div class="form-group">
                <asp:Label ID="lblPaymentMode" runat="server"
                    AssociatedControlID="ddlPaymentMode"
                    CssClass="form-label"
                    Text="Payment Mode"></asp:Label>

                <asp:DropDownList ID="ddlPaymentMode" runat="server" CssClass="form-control form-select">
                    <asp:ListItem Value="Cash" Text="Cash" Selected="True" />
                    <asp:ListItem Value="Pending" Text="Pending" />
                </asp:DropDownList>
            </div>

        </div>

        <%-- =========================== ITEM DETAILS ========================== --%>
        <h3 class="sub-title">Item Details</h3>

        <%-- Static rows of the design bill BIL-201 (no Repeater, no handlers). --%>
        <table class="item-table">
            <thead>
                <tr>
                    <th>Item Name</th>
                    <th>Quantity</th>
                    <th>Rate (&#8377;)</th>
                    <th>Amount (&#8377;)</th>
                    <th class="act">Action</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td class="cell-name">
                        <input type="text" class="form-control item-input" value="Dell 24&quot; IPS Monitor" />
                    </td>
                    <td class="cell-qty">
                        <input type="text" class="form-control item-input-sm" value="1" />
                    </td>
                    <td class="cell-rate">
                        <input type="text" class="form-control item-input-sm" value="11500" />
                    </td>
                    <td class="cell-amt">&#8377; 11,500.00</td>
                    <td class="act">
                        <button type="button" class="btn-trash">&#128465;</button>
                    </td>
                </tr>
                <tr>
                    <td class="cell-name">
                        <input type="text" class="form-control item-input" value="Wireless Mouse &amp; Keyboard Combo" />
                    </td>
                    <td class="cell-qty">
                        <input type="text" class="form-control item-input-sm" value="1" />
                    </td>
                    <td class="cell-rate">
                        <input type="text" class="form-control item-input-sm" value="1350" />
                    </td>
                    <td class="cell-amt">&#8377; 1,350.00</td>
                    <td class="act">
                        <button type="button" class="btn-trash">&#128465;</button>
                    </td>
                </tr>
            </tbody>
        </table>

        <div class="entry-tools">
            <%-- Static "+ Add Item" button of the design (no handler). --%>
            <button type="button" class="btn-green">+  Add Item</button>
        </div>

        <hr class="entry-rule" />

        <div class="entry-foot">
            <div class="grand-total">
                <span class="grand-label">Grand Total:</span>
                <asp:Label ID="lblGrandTotal" runat="server" CssClass="grand-value" Text="&#8377; 12,850.00" />
            </div>

            <div class="entry-actions">
                <%-- Static buttons of the design (no server handlers yet). --%>
                <button type="button" class="btn-reset">Cancel</button>
                <button type="button" class="btn-save">Update Invoice</button>
            </div>
        </div>

    </div>

</asp:Content>
