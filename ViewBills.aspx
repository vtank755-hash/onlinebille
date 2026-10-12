<%@ Page Title="View Bills" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="ViewBills.aspx.cs" Inherits="vivektank1.ViewBills" %>

<%-- View Bills - the list of every bill.
     The From Date / To Date fields, the Status (Cash / Pending) options
     and the Search Customer box are static UI only in this stage:
     no date filtering, no status filtering and no name search.
     Database phase: the same list from SQL Server with
       SELECT BillNo, BillDate, Customer, Amount, Status FROM Bills --%>
<asp:Content ID="ViewBillsContent" ContentPlaceHolderID="DashContent" runat="server">

    <%-- ============================ FILTERS ============================ --%>
    <div class="vb-filters">

        <div class="vb-field">
            <asp:Label ID="lblFromDate" runat="server" AssociatedControlID="txtFromDate"
                CssClass="form-label" Text="From Date"></asp:Label>
            <asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control"
                placeholder="16-May-2026"></asp:TextBox>
            <asp:RegularExpressionValidator ID="revFromDate" runat="server"
                ControlToValidate="txtFromDate"
                ValidationExpression="([0-2][0-9]|3[01])-(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)-[0-9]{4}"
                ErrorMessage="Enter the date like 16-May-2026."
                CssClass="field-validator" Display="Dynamic" SetFocusOnError="true">
            </asp:RegularExpressionValidator>
        </div>

        <div class="vb-field">
            <asp:Label ID="lblToDate" runat="server" AssociatedControlID="txtToDate"
                CssClass="form-label" Text="To Date"></asp:Label>
            <asp:TextBox ID="txtToDate" runat="server" CssClass="form-control"
                placeholder="20-May-2026"></asp:TextBox>
            <asp:RegularExpressionValidator ID="revToDate" runat="server"
                ControlToValidate="txtToDate"
                ValidationExpression="([0-2][0-9]|3[01])-(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)-[0-9]{4}"
                ErrorMessage="Enter the date like 20-May-2026."
                CssClass="field-validator" Display="Dynamic" SetFocusOnError="true">
            </asp:RegularExpressionValidator>
        </div>

        <div class="vb-field">
            <asp:Label ID="lblStatus" runat="server" AssociatedControlID="ddlStatus"
                CssClass="form-label" Text="Status"></asp:Label>
            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                <asp:ListItem Text="All Statuses" Value="" Selected="True"></asp:ListItem>
                <asp:ListItem Text="Cash" Value="Cash"></asp:ListItem>
                <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
            </asp:DropDownList>
        </div>

        <div class="vb-field vb-field-search">
            <asp:Label ID="lblSearch" runat="server" AssociatedControlID="txtSearch"
                CssClass="form-label" Text="Search Customer"></asp:Label>
            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"
                placeholder="Search by customer name..."></asp:TextBox>
        </div>

        <asp:Button ID="btnSearch" runat="server" Text="Search"
            CssClass="btn-primary vb-search-btn" CausesValidation="false" />

        <asp:Button ID="btnClear" runat="server" Text="Clear"
            CssClass="btn-reset vb-search-btn" CausesValidation="false" />

    </div>

    <%-- ============================= LIST ============================== --%>
    <asp:Panel ID="pnlBills" runat="server" CssClass="panel">

        <table class="dash-table">
            <thead>
                <tr>
                    <th>Bill No</th>
                    <th>Date</th>
                    <th>Customer Name</th>
                    <th class="num">Amount</th>
                    <th>Status</th>
                    <th class="act">Action</th>
                </tr>
            </thead>
            <tbody>
                <%-- Data binding: bills saved in Bill Entry (Session) on top,
                     design sample rows below. The fields above the table
                     are static UI (no filtering in this stage).
                     Database phase: SqlDataAdapter fills the same Repeater. --%>
                <asp:Repeater ID="rptBills" runat="server">
                    <ItemTemplate>
                        <tr>
                            <td class="billno"><%# Eval("BillNo") %></td>
                            <td><%# Eval("BillDate") %></td>
                            <td class="cust"><%# Eval("Customer") %></td>
                            <td class="num">&#8377; <%# Eval("AmountText") %></td>
                            <td><span class="badge <%# Eval("BadgeCss") %>"><%# Eval("Status") %></span></td>
                            <td class="act">
                                <a class="btn-view" href='BillDetails.aspx?bill=<%# Eval("BillNo") %>'>
                                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><path d="M2.5 12S6 5.8 12 5.8 21.5 12 21.5 12 18 18.2 12 18.2 2.5 12 2.5 12z" /><circle cx="12" cy="12" r="3" /></svg>View</a>
                                <a class="btn-edit" href="BillEntryEdit.aspx" title="Edit bill">
                                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><path d="M4 20h4l11-11-4-4L4 16z" /><path d="M13.8 5.4l4.8 4.8" /></svg></a>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>

        <%-- Shown when no bill matches the filters. --%>
        <asp:Label ID="lblEmpty" runat="server" CssClass="vb-empty"
            Text="No bills found for the selected filters."
            Visible="false"></asp:Label>

        <div class="vb-foot">
            <asp:Label ID="lblTotalRecords" runat="server" CssClass="vb-total"
                Text="Total Records: 0"></asp:Label>
        </div>

    </asp:Panel>

</asp:Content>
