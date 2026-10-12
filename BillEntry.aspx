<%@ Page Title="Bill Entry" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="BillEntry.aspx.cs" Inherits="vivektank1.BillEntry" %>

<%-- Bill Entry - create a new invoice.
     Layout follows the Figma design; every guarded field uses an ASP.NET
     Validation Control that prints its red message ONLY under that field.
     The item rows live in a Repeater kept in ViewState (state management);
     saving the invoice to SQL Server with ADO.NET comes in the database step. --%>
<asp:Content ID="BillEntryContent" ContentPlaceHolderID="DashContent" runat="server">

    <div class="panel entry-panel">

        <h2 class="panel-title entry-title">Customer &amp; Invoice Details</h2>

        <div class="form-grid">

            <%-- ---------------------------- CUSTOMER --------------------------- --%>
            <div class="form-group">
                <asp:Label ID="lblCustomer" runat="server"
                    AssociatedControlID="ddlCustomer"
                    CssClass="form-label"
                    Text="Customer Name"></asp:Label>

                <div class="customer-pick">
                    <asp:DropDownList ID="ddlCustomer" runat="server"
                        CssClass="form-control form-select"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ddlCustomer_SelectedIndexChanged">
                        <asp:ListItem Value="" Text="-- Select Customer --" />
                        <asp:ListItem Value="Rahul Patel" Text="Rahul Patel" />
                        <asp:ListItem Value="Anjali Gupta" Text="Anjali Gupta" />
                        <asp:ListItem Value="Amit Yadav" Text="Amit Yadav" />
                        <asp:ListItem Value="Raj Mehta" Text="Raj Mehta" />
                        <asp:ListItem Value="Pooja Sharma" Text="Pooja Sharma" />
                    </asp:DropDownList>

                    <asp:Button ID="btnAddCustomer" runat="server"
                        Text="+"
                        CssClass="btn-plus"
                        CausesValidation="false"
                        OnClick="btnAddCustomer_Click"
                        ToolTip="Add new customer" />
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
                    MaxLength="10"
                    Placeholder="Enter mobile number"></asp:TextBox>
            </div>

            <%-- ----------------------------- ADDRESS --------------------------- --%>
            <div class="form-group">
                <asp:Label ID="lblAddress" runat="server"
                    AssociatedControlID="txtAddress"
                    CssClass="form-label"
                    Text="Address"></asp:Label>

                <asp:TextBox ID="txtAddress" runat="server"
                    CssClass="form-control"
                    Placeholder="Enter complete address"></asp:TextBox>
            </div>

            <%-- ---------------------------- BILL DATE -------------------------- --%>
            <div class="form-group">
                <asp:Label ID="lblBillDate" runat="server"
                    AssociatedControlID="txtBillDate"
                    CssClass="form-label"
                    Text="Bill Date"></asp:Label>

                <asp:TextBox ID="txtBillDate" runat="server"
                    CssClass="form-control"
                    Placeholder="Select bill date (DD-MM-YYYY)"></asp:TextBox>
            </div>

            <%-- --------------------------- BILL NUMBER ------------------------- --%>
            <div class="form-group">
                <asp:Label ID="lblBillNumber" runat="server"
                    AssociatedControlID="txtBillNumber"
                    CssClass="form-label"
                    Text="Bill Number"></asp:Label>

                <%-- Auto-generated in the code-behind:
                     BIL-yyyyMMddHHmmss-4 random digits, e.g. BIL-20260930143052-4721
                     - read only --%>
                <asp:TextBox ID="txtBillNumber" runat="server"
                    CssClass="form-control"
                    ReadOnly="true"
                    Placeholder="Auto-generated (e.g. BIL-20260930143052-4721)"></asp:TextBox>
            </div>

            <%-- -------------------------- PAYMENT MODE ------------------------- --%>
            <div class="form-group">
                <asp:Label ID="lblPaymentMode" runat="server"
                    AssociatedControlID="ddlPaymentMode"
                    CssClass="form-label"
                    Text="Payment Mode"></asp:Label>

                <asp:DropDownList ID="ddlPaymentMode" runat="server" CssClass="form-control form-select">
                    <asp:ListItem Value="Cash" Text="Cash" />
                    <asp:ListItem Value="Pending" Text="Pending" />
                </asp:DropDownList>
            </div>

        </div>

        <%-- =========================== ITEM DETAILS ========================== --%>
        <h3 class="sub-title">Item Details</h3>

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
                <asp:Repeater ID="rptItems" runat="server">
                    <ItemTemplate>
                        <tr>
                            <td class="cell-name">
                                <asp:TextBox ID="txtItemName" runat="server"
                                    CssClass="form-control item-input"
                                    Placeholder="e.g. Laptop Charger"
                                    Text='<%# Eval("ItemName") %>'></asp:TextBox>
                            </td>
                            <td class="cell-qty">
                                <asp:TextBox ID="txtQty" runat="server"
                                    CssClass="form-control item-input-sm"
                                    AutoPostBack="true"
                                    OnTextChanged="ItemField_Changed"
                                    Text='<%# Eval("Qty") %>'></asp:TextBox>
                            </td>
                            <td class="cell-rate">
                                <asp:TextBox ID="txtRate" runat="server"
                                    CssClass="form-control item-input-sm"
                                    AutoPostBack="true"
                                    OnTextChanged="ItemField_Changed"
                                    Text='<%# Eval("Rate") %>'></asp:TextBox>
                            </td>
                            <td class="cell-amt">
                                <%# FormatAmount(Eval("Qty"), Eval("Rate")) %>
                            </td>
                            <td class="act">
                                <asp:Button ID="btnDeleteRow" runat="server"
                                    CssClass="btn-trash"
                                    Text="&#128465;"
                                    ToolTip="Remove item"
                                    CausesValidation="false"
                                    OnClick="btnDeleteRow_Click" />
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>

        <div class="entry-tools">
            <asp:Button ID="btnAddItem" runat="server"
                Text="+  Add Item"
                CssClass="btn-green"
                CausesValidation="false"
                OnClick="btnAddItem_Click" />
        </div>

        <hr class="entry-rule" />

        <div class="entry-foot">
            <div class="grand-total">
                <span class="grand-label">Grand Total:</span>
                <asp:Label ID="lblGrandTotal" runat="server" CssClass="grand-value" Text="&#8377; 1,500.00" />
            </div>

            <div class="entry-actions">
                <asp:Button ID="btnReset" runat="server"
                    Text="Reset"
                    CssClass="btn-reset"
                    CausesValidation="false"
                    OnClick="btnReset_Click" />

                <asp:Button ID="btnSave" runat="server"
                    Text="Save Invoice"
                    CssClass="btn-save"
                    ValidationGroup="vgBill"
                    OnClick="btnSave_Click" />
            </div>
        </div>

    </div>

</asp:Content>
