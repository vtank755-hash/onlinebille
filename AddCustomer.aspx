<%@ Page Title="Add Customer" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="AddCustomer.aspx.cs" Inherits="vivektank1.AddCustomer" %>

<%-- Add Customer - opened by the "+" button next to Customer Name on
     Bill Entry. Every mandatory field uses an ASP.NET Validation Control
     that prints its red message ONLY under that field. The saved customer
     goes into Session["Customers"] and appears in the Bill Entry dropdown;
     saving into SQL Server with ADO.NET comes in the database step. --%>
<asp:Content ID="AddCustomerContent" ContentPlaceHolderID="DashContent" runat="server">

    <div class="panel cust-panel">

        <%-- ------------------------- CARD HEADER -------------------------- --%>
        <div class="cust-head">
            <div class="cust-head-text">
                <h2 class="panel-title cust-title">Customer Registration Details</h2>
                <p class="cust-sub">Enter primary client information for streamlined invoicing and billing records.</p>
            </div>

            <%-- Auto-generated customer id: CST-1048, CST-1049, ... --%>
            <asp:Label ID="lblCustId" runat="server"
                CssClass="cust-id"
                Text="Auto ID: CST-1048"></asp:Label>
        </div>

        <hr class="cust-rule" />

        <%-- ---------------------------- FIELDS --------------------------- --%>
        <div class="form-grid cust-grid">

            <div class="form-group">
                <label class="form-label" for="<%= txtName.ClientID %>">Customer Name <span class="req-star">*</span></label>
                <asp:TextBox ID="txtName" runat="server"
                    CssClass="form-control"
                    Placeholder="e.g. Rahul Sharma"></asp:TextBox>

                <asp:RequiredFieldValidator ID="rfvName" runat="server"
                    ControlToValidate="txtName"
                    ValidationGroup="vgCustomer"
                    ErrorMessage="Customer Name is required."
                    Text="Customer Name is required."
                    CssClass="field-validator"
                    Display="Dynamic">*</asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label class="form-label" for="<%= txtMobile.ClientID %>">Mobile Number <span class="req-star">*</span></label>
                <asp:TextBox ID="txtMobile" runat="server"
                    CssClass="form-control"
                    MaxLength="10"
                    Placeholder="+91   98765 43210"></asp:TextBox>

                <asp:RequiredFieldValidator ID="rfvMobile" runat="server"
                    ControlToValidate="txtMobile"
                    ValidationGroup="vgCustomer"
                    ErrorMessage="Mobile Number is required"
                    Text="Mobile Number is required"
                    CssClass="field-validator"
                    Display="Dynamic">*</asp:RequiredFieldValidator>

                <asp:RegularExpressionValidator ID="revMobile" runat="server"
                    ControlToValidate="txtMobile"
                    ValidationExpression="^\d{10}$"
                    ValidationGroup="vgCustomer"
                    ErrorMessage="Mobile Number must be 10 digits"
                    Text="Mobile Number must be 10 digits"
                    CssClass="field-validator"
                    Display="Dynamic">*</asp:RegularExpressionValidator>
            </div>

            <div class="form-group cust-span">
                <label class="form-label" for="<%= txtAddress.ClientID %>">Billing Address <span class="req-star">*</span></label>
                <asp:TextBox ID="txtAddress" runat="server"
                    CssClass="form-control cust-area"
                    TextMode="MultiLine"
                    Placeholder="Enter complete address (Flat/Plot No., Street, Landmark, Area)"></asp:TextBox>

                <asp:RequiredFieldValidator ID="rfvAddress" runat="server"
                    ControlToValidate="txtAddress"
                    ValidationGroup="vgCustomer"
                    ErrorMessage="Billing Address is required."
                    Text="Billing Address is required."
                    CssClass="field-validator"
                    Display="Dynamic">*</asp:RequiredFieldValidator>
            </div>

        </div>

        <hr class="cust-rule" />

        <%-- ------------------------- CARD FOOTER -------------------------- --%>
        <div class="cust-foot">
            <span class="cust-note">
                <span class="cust-dot"></span>
                Fields marked with <span class="req-star">*</span> are mandatory
            </span>

            <div class="entry-actions">
                <asp:Button ID="btnReset" runat="server"
                    Text="Reset"
                    CssClass="btn-reset"
                    CausesValidation="false"
                    OnClick="btnReset_Click" />

                <asp:Button ID="btnSave" runat="server"
                    Text="✓ Save Customer"
                    CssClass="btn-save"
                    ValidationGroup="vgCustomer"
                    OnClick="btnSave_Click" />
            </div>
        </div>

    </div>

</asp:Content>
