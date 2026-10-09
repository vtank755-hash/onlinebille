f<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="vivektank1.Index" %>

<%-- Home page: STATIC ONLY.
     No database, no ADO.NET, no SQL Server, no CRUD, no authentication,
     no registration processing, no Session, no ViewState and no billing
     calculation. Login / Register are plain UI links only. --%>
<asp:Content ID="HomeContent" ContentPlaceHolderID="MainContent" runat="server">

    <section class="hero" aria-labelledby="heroTitle">

        <div class="hero-media">
            <img class="hero-img"
                src="<%: ResolveUrl("~/Content/images/hero-billing.svg") %>"
                alt="Laptop showing an invoice dashboard next to printed bills" />
        </div>

        <h1 class="hero-title" id="heroTitle">Manage Your<br class="hero-br" />
            Invoices &amp; Bills<br class="hero-br" />
            with Absolute Ease</h1>

        <p class="hero-subtitle">Describe bills, log payments, view summary charts, and track clients on our blazing fast college-grade Online Billing platform.</p>

        <%-- Static links only - no authentication logic on this page. --%>
        <div class="hero-actions">
            <asp:HyperLink ID="lnkHeroLogin" runat="server"
                NavigateUrl="~/Login.aspx"
                CssClass="hero-btn hero-btn-solid">Login</asp:HyperLink>

            <asp:HyperLink ID="lnkHeroRegister" runat="server"
                NavigateUrl="~/Register.aspx"
                CssClass="hero-btn hero-btn-outline">Register</asp:HyperLink>
        </div>

    </section>

</asp:Content>
