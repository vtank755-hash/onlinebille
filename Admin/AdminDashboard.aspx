<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="vivektank1.AdminDashboard" %>

<%-- Admin Dashboard - the main admin panel page (Admin.Master provides the
     dark indigo sidebar and the white top bar).
     Shows the user statistics cards and the user list table.
     Database phase: fill the values with ADO.NET from SQL Server. --%>
<asp:Content ID="AdminDashboardContent" ContentPlaceHolderID="AdminContent" runat="server">

    <%-- =========================== STAT CARDS ========================== --%>
    <div class="admin-stat-grid">

        <a class="admin-stat-card admin-stat-card-link" href="AdminAllUsers.aspx">
            <span class="admin-stat-icon admin-stat-icon-blue">
                <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                    <circle cx="8" cy="7.5" r="3.2" />
                    <path d="M2 17c.8-2.8 2.9-4.4 6-4.4s5.2 1.6 6 4.4H2z" />
                    <circle cx="16.5" cy="8.5" r="2.6" />
                    <path d="M15.5 13.2c2.7.1 4.7 1.7 5.5 4.3h-4.1c-.3-1.6-1-3-2.1-4.1z" />
                </svg>
            </span>
            <span class="admin-stat-text">
                <span class="admin-stat-label">Total Users</span>
                <span class="admin-stat-value">150</span>
            </span>
        </a>

        <a class="admin-stat-card admin-stat-card-link" href="AdminActiveUsers.aspx">
            <span class="admin-stat-icon admin-stat-icon-green">
                <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                    <circle cx="10.5" cy="7.5" r="3.5" />
                    <path d="M4 17c.9-2.8 3.2-4.4 6.5-4.4S14.1 14.2 15 17H4z" />
                    <path fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" d="M16.2 18.8l1.7 1.7 3.5-3.7" />
                </svg>
            </span>
            <span class="admin-stat-text">
                <span class="admin-stat-label">Active Users</span>
                <span class="admin-stat-value">120</span>
            </span>
        </a>

        <a class="admin-stat-card admin-stat-card-link" href="AdminInactiveUsers.aspx">
            <span class="admin-stat-icon admin-stat-icon-red">
                <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                    <circle cx="10.5" cy="7.5" r="3.5" />
                    <path d="M4 17c.9-2.8 3.2-4.4 6.5-4.4S14.1 14.2 15 17H4z" />
                    <path fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" d="M17 17l4.2 4.2M21.2 17L17 21.2" />
                </svg>
            </span>
            <span class="admin-stat-text">
                <span class="admin-stat-label">Inactive Users</span>
                <span class="admin-stat-value">30</span>
            </span>
        </a>

        <a class="admin-stat-card admin-stat-card-link" href="AdminNewUsers.aspx">
            <span class="admin-stat-icon admin-stat-icon-purple">
                <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                    <circle cx="9.5" cy="7.5" r="3.5" />
                    <path d="M3 17c.9-2.8 3.2-4.4 6.5-4.4S12.6 14.2 13.5 17H3z" />
                    <path fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" d="M18.8 15.4v5.2M16.2 18h5.2" />
                </svg>
            </span>
            <span class="admin-stat-text">
                <span class="admin-stat-label">New Users</span>
                <span class="admin-stat-value">15</span>
            </span>
        </a>

    </div>

    <%-- ============================ USER LIST =========================== --%>
    <div class="admin-panel">

        <div class="admin-panel-head">
            <h2 class="admin-panel-title">User List</h2>
            <div class="admin-panel-actions">
                <button type="button" class="admin-btn-outline">
                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <path d="M3 5h18l-7 8v5.5l-4 2V13L3 5z" />
                    </svg>
                    Filter Status
                </button>
                <button type="button" class="admin-btn-primary">
                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" aria-hidden="true">
                        <path d="M12 5v14M5 12h14" />
                    </svg>
                    Add User
                </button>
            </div>
        </div>

        <div class="admin-table-wrap">
            <table class="admin-table admin-user-table">
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>User Name</th>
                        <th>Email</th>
                        <th>Mobile Number</th>
                        <th>Total Bills</th>
                        <th>Total Amount</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><a class="admin-user-id" href="#">USR-001</a></td>
                        <td>
                            <span class="admin-user-cell">
                                <span class="admin-avatar admin-avatar-blue">RS</span>
                                <span class="admin-user-name">Rahul Sharma</span>
                            </span>
                        </td>
                        <td>rahul@email.com</td>
                        <td>9876543210</td>
                        <td>25</td>
                        <td class="admin-amount">&#8377;1,25,000</td>
                        <td><span class="admin-badge-active">Active</span></td>
                        <td>
                            <span class="admin-actions">
                                <a class="admin-icon-btn" href="AdminUserProfile.aspx" title="View">
                                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                                        <path d="M12 5C6.5 5 2.7 9.4 2 12c.7 2.6 4.5 7 10 7s9.3-4.4 10-7c-.7-2.6-4.5-7-10-7zm0 11.5A4.5 4.5 0 1 1 12 7.5a4.5 4.5 0 0 1 0 9zm0-2a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5z" />
                                    </svg>
                                </a>
                                <a class="admin-icon-btn" href="AdminEditUser.aspx" title="Edit">
                                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                                        <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04a1 1 0 0 0 0-1.41l-2.34-2.34a1 1 0 0 0-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z" />
                                    </svg>
                                </a>
                                <button type="button" class="admin-icon-btn admin-icon-danger" title="Delete">
                                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                                        <path d="M9 3h6a1 1 0 0 1 1 1v1h4.5v2H3.5V5H8V4a1 1 0 0 1 1-1zm-2.5 6h11l-.93 11.2A1.5 1.5 0 0 1 16.07 21H7.93a1.5 1.5 0 0 1-1.5-1.38L5.5 9z" />
                                    </svg>
                                </button>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td><a class="admin-user-id" href="#">USR-002</a></td>
                        <td>
                            <span class="admin-user-cell">
                                <span class="admin-avatar admin-avatar-green">PP</span>
                                <span class="admin-user-name">Priya Patel</span>
                            </span>
                        </td>
                        <td>priya@email.com</td>
                        <td>9876543211</td>
                        <td>18</td>
                        <td class="admin-amount">&#8377;85,500</td>
                        <td><span class="admin-badge-active">Active</span></td>
                        <td>
                            <span class="admin-actions">
                                <a class="admin-icon-btn" href="AdminUserProfile.aspx" title="View">
                                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                                        <path d="M12 5C6.5 5 2.7 9.4 2 12c.7 2.6 4.5 7 10 7s9.3-4.4 10-7c-.7-2.6-4.5-7-10-7zm0 11.5A4.5 4.5 0 1 1 12 7.5a4.5 4.5 0 0 1 0 9zm0-2a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5z" />
                                    </svg>
                                </a>
                                <a class="admin-icon-btn" href="AdminEditUser.aspx" title="Edit">
                                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                                        <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04a1 1 0 0 0 0-1.41l-2.34-2.34a1 1 0 0 0-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z" />
                                    </svg>
                                </a>
                                <button type="button" class="admin-icon-btn admin-icon-danger" title="Delete">
                                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                                        <path d="M9 3h6a1 1 0 0 1 1 1v1h4.5v2H3.5V5H8V4a1 1 0 0 1 1-1zm-2.5 6h11l-.93 11.2A1.5 1.5 0 0 1 16.07 21H7.93a1.5 1.5 0 0 1-1.5-1.38L5.5 9z" />
                                    </svg>
                                </button>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td><a class="admin-user-id" href="#">USR-003</a></td>
                        <td>
                            <span class="admin-user-cell">
                                <span class="admin-avatar admin-avatar-purple">VM</span>
                                <span class="admin-user-name">Vikram Malhotra</span>
                            </span>
                        </td>
                        <td>vikram@email.com</td>
                        <td>9876543212</td>
                        <td>12</td>
                        <td class="admin-amount">&#8377;45,000</td>
                        <td><span class="admin-badge-inactive">Inactive</span></td>
                        <td>
                            <span class="admin-actions">
                                <a class="admin-icon-btn" href="AdminUserProfile.aspx" title="View">
                                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                                        <path d="M12 5C6.5 5 2.7 9.4 2 12c.7 2.6 4.5 7 10 7s9.3-4.4 10-7c-.7-2.6-4.5-7-10-7zm0 11.5A4.5 4.5 0 1 1 12 7.5a4.5 4.5 0 0 1 0 9zm0-2a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5z" />
                                    </svg>
                                </a>
                                <a class="admin-icon-btn" href="AdminEditUser.aspx" title="Edit">
                                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                                        <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04a1 1 0 0 0 0-1.41l-2.34-2.34a1 1 0 0 0-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z" />
                                    </svg>
                                </a>
                                <button type="button" class="admin-icon-btn admin-icon-danger" title="Delete">
                                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                                        <path d="M9 3h6a1 1 0 0 1 1 1v1h4.5v2H3.5V5H8V4a1 1 0 0 1 1-1zm-2.5 6h11l-.93 11.2A1.5 1.5 0 0 1 16.07 21H7.93a1.5 1.5 0 0 1-1.5-1.38L5.5 9z" />
                                    </svg>
                                </button>
                            </span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="admin-table-foot">
            <span class="admin-table-info">Showing 3 of 150 entries</span>
            <div class="admin-pagination">
                <button type="button" class="admin-page-btn">Previous</button>
                <button type="button" class="admin-page-btn is-current">1</button>
                <button type="button" class="admin-page-btn">2</button>
                <button type="button" class="admin-page-btn">3</button>
                <button type="button" class="admin-page-btn">Next</button>
            </div>
        </div>

    </div>

</asp:Content>
