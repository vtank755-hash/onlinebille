<%@ Page Title="Bill Details" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="BillDetails.aspx.cs" Inherits="vivektank1.BillDetails" %>

<%-- Bill Details - the full invoice of ONE bill.
     Opened with ?bill=BIL-... from the View buttons of the Dashboard
     and the View Bills list. Bills saved in Bill Entry come from
     Session["SavedBills"] / Session["BillItems"]; the five design bills
     use their sample items. Status is always shown as Cash or Pending. --%>
<asp:Content ID="BillDetailsContent" ContentPlaceHolderID="DashContent" runat="server">

    <%-- Shown when the bill number of the address bar is unknown. --%>
    <asp:Label ID="lblNotFound" runat="server"
        CssClass="vb-notfound"
        Text="Bill not found. Go back and try again."
        Visible="false"></asp:Label>

    <asp:Panel ID="pnlCard" runat="server" CssClass="inv-card">

        <%-- ========================= INVOICE HEAD ========================= --%>
        <div class="inv-head">
            <div>
                <div class="inv-title">INVOICE</div>
                <div class="inv-sub">Online Billing System</div>
            </div>
            <div>
                <div class="inv-no">Bill No: <asp:Label ID="lblBillNo" runat="server" Text="BIL-201" /></div>
                <div class="inv-date">Date: <asp:Label ID="lblDate" runat="server" Text="16-May-2026" /></div>
            </div>
        </div>

        <hr class="inv-rule" />

        <%-- ====================== BILL TO / PAYMENT ======================= --%>
        <div class="inv-cols">

            <div class="inv-col">
                <div class="inv-k">Bill To:</div>
                <div class="inv-name"><asp:Label ID="lblCustomer" runat="server" Text="Rahul Patel" /></div>
                <div class="inv-line">Mobile: <asp:Label ID="lblMobile" runat="server" /></div>
                <div class="inv-line">Address: <asp:Label ID="lblAddress" runat="server" /></div>
            </div>

            <div class="inv-col">
                <div class="inv-k">Payment Details:</div>
                <div class="inv-line">Payment Mode:
                    <asp:Label ID="lblMode" runat="server" CssClass="inv-strong" Text="Cash" /></div>
                <div class="inv-line">Status:
                    <asp:Label ID="lblStatus" runat="server" CssClass="badge badge-cash" Text="Cash" /></div>
            </div>

        </div>

        <%-- ========================== ITEM TABLE ========================== --%>
        <table class="inv-table">
            <thead>
                <tr>
                    <th>S.No</th>
                    <th>Item Name</th>
                    <th>Quantity</th>
                    <th class="ta-r">Rate</th>
                    <th class="ta-r">Amount</th>
                </tr>
            </thead>
            <tbody>
                <asp:Repeater ID="rptItems" runat="server">
                    <ItemTemplate>
                        <tr>
                            <td class="inv-sno"><%# Eval("Sno") %></td>
                            <td class="inv-item"><%# Eval("ItemName") %></td>
                            <td><%# Eval("Qty") %></td>
                            <td class="ta-r">&#8377; <%# Eval("RateText") %></td>
                            <td class="ta-r inv-amt">&#8377; <%# Eval("AmountText") %></td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>

        <asp:Label ID="lblNoItems" runat="server"
            CssClass="vb-notfound"
            Text="Item rows of this bill are not stored yet (they arrive with the database phase)."
            Visible="false"></asp:Label>

        <%-- ============================ TOTALS ============================ --%>
        <div class="inv-subtotal-row">
            Subtotal: <span class="inv-strong">&#8377; <asp:Label ID="lblSubtotal" runat="server" Text="0.00" /></span>
        </div>

        <div class="inv-grand">
            <span class="inv-grand-lbl">Grand Total:</span>
            <span class="inv-grand-amt">&#8377; <asp:Label ID="lblGrandTotal" runat="server" Text="0.00" /></span>
        </div>

    </asp:Panel>

    <div class="inv-actions">
        <asp:Button ID="btnBack" runat="server"
            Text="Back to View Bills"
            CssClass="btn-primary inv-btn"
            CausesValidation="false"
            OnClick="btnBack_Click" />
    </div>

</asp:Content>
