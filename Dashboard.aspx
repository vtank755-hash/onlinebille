<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="vivektank1.Dashboard" %>

<%-- Dashboard - overview of bills. The three summary cards and the
     Recent Bills table are data-bound in the code-behind: bills saved in
     Bill Entry arrive through Session["SavedBills"]; in the database phase
     the same Repeater is filled with ADO.NET (SqlDataAdapter + DataSet). --%>
<asp:Content ID="DashboardContent" ContentPlaceHolderID="DashContent" runat="server">

    <%-- Toast message - shown only after a bill was saved in Bill Entry
         (the redirect arrives as Dashboard.aspx?saved=1&bill=...).
         It hides itself after a few seconds (CSS animation). --%>
    <asp:Panel ID="pnlToast" runat="server" CssClass="toast" Visible="false">
        <span class="toast-check">&#10003;</span>
        <span class="toast-body">
            <asp:Label ID="lblToastTitle" runat="server"
                CssClass="toast-title"
                Text="Bill saved successfully"></asp:Label>
            <asp:Label ID="lblToastMsg" runat="server"
                CssClass="toast-msg" />
        </span>
    </asp:Panel>

    <%-- ========================== SUMMARY CARDS ========================== --%>
    <div class="stat-grid">

        <div class="stat-card">
            <span class="stat-icon stat-icon-blue">
                <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                    <path d="M7 3h7l4.5 4.5V21H7z" />
                    <path d="M13.6 3v5h4.7" />
                </svg>
            </span>
            <span class="stat-text">
                <span class="stat-label">Total Bills</span>
                <asp:Label ID="lblTotalBills" runat="server"
                    CssClass="stat-value"
                    Text="35"></asp:Label>
            </span>
        </div>

        <div class="stat-card">
            <span class="stat-icon stat-icon-green">
                <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                    <path d="M7 5h10" />
                    <path d="M7 9h10" />
                    <path d="M13.5 5v9c0 2.5-1.6 4-3.7 4" />
                </svg>
            </span>
            <span class="stat-text">
                <span class="stat-label">Total Amount</span>
                <asp:Label ID="lblTotalAmount" runat="server"
                    CssClass="stat-value"
                    Text="&#8377; 1,25,430"></asp:Label>
            </span>
        </div>

        <div class="stat-card">
            <span class="stat-icon stat-icon-teal">
                <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                    <rect x="3.5" y="6" width="17" height="12.5" rx="2.2" />
                    <path d="M3.5 10h17" />
                    <circle cx="16.8" cy="14.6" r="1.3" />
                </svg>
            </span>
            <span class="stat-text">
                <span class="stat-label">Paid Amount</span>
                <asp:Label ID="lblPaidAmount" runat="server"
                    CssClass="stat-value"
                    Text="&#8377; 98,430"></asp:Label>
            </span>
        </div>

    </div>

    <%-- =========================== RECENT BILLS ========================== --%>
    <div class="panel">

        <div class="panel-head">
            <h2 class="panel-title">Recent Bills</h2>
            <button type="button" class="btn-filter">Filter Status</button>
        </div>

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
                     design sample rows below. Database phase: the same
                     Repeater is filled from SQL Server with
                     SqlDataAdapter + DataSet. --%>
                <asp:Repeater ID="rptRecentBills" runat="server">
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

        <div class="panel-foot">
            <a class="btn-primary" href="ViewBills.aspx">View All Bills</a>
        </div>

    </div>

</asp:Content>
