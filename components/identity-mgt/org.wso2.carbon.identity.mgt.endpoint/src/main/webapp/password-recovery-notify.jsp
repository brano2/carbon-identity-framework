<%--
  ~ Copyright (c) 2016, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
  ~
  ~  WSO2 Inc. licenses this file to you under the Apache License,
  ~  Version 2.0 (the "License"); you may not use this file except
  ~  in compliance with the License.
  ~  You may obtain a copy of the License at
  ~
  ~    http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing,
  ~ software distributed under the License is distributed on an
  ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  ~ KIND, either express or implied.  See the License for the
  ~ specific language governing permissions and limitations
  ~ under the License.
  --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="org.owasp.encoder.Encode" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.IdentityManagementEndpointConstants" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.IdentityManagementEndpointUtil" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.client.ApiException" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.client.api.NotificationApi" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.client.model.RecoveryInitiatingRequest" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.client.model.User" %>
<%@ page import="org.wso2.carbon.identity.mgt.util.Utils" %>
<%@ page import="org.wso2.carbon.utils.multitenancy.MultitenantUtils" %>

<%


    String username = IdentityManagementEndpointUtil.getStringValue(request.getAttribute("username"));

    String userStoreDomain = Utils.getUserStoreDomainName(username);
    String tenantDomain = MultitenantUtils.getTenantDomain(username);

    User user = new User();
    user.setUsername(username);
    user.setTenantDomain(tenantDomain);
    user.setRealm(userStoreDomain);

    NotificationApi notificationApi = new NotificationApi();

    RecoveryInitiatingRequest recoveryInitiatingRequest = new RecoveryInitiatingRequest();
    recoveryInitiatingRequest.setUser(user);

    try {
        notificationApi.recoverPasswordPost(recoveryInitiatingRequest, null, null);
    } catch (ApiException e) {
        request.setAttribute("error", true);
        request.setAttribute("errorMsg", e.getMessage());
        request.getRequestDispatcher("error.jsp").forward(request, response);
        return;
    }

%>
<html>
<head>
    <link href="libs/bootstrap_3.3.5/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/Roboto.css" rel="stylesheet">
    <link href="css/custom-common.css" rel="stylesheet">
</head>
<body>
<div class="container">
    <div id="infoModel" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Information</h4>
                </div>
                <div class="modal-body">
                    <p>Password recovery information has been sent to the email registered
                        with the account <%=Encode.forHtml(username)%>
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="libs/jquery_1.11.3/jquery-1.11.3.js"></script>
<script src="libs/bootstrap_3.3.5/js/bootstrap.min.js"></script>
<script type="application/javascript">
    $(document).ready(function () {
        var infoModel = $("#infoModel");
        infoModel.modal("show");
        infoModel.on('hidden.bs.modal', function () {
            location.href = "<%=Encode.forJavaScript(IdentityManagementEndpointUtil.getUserPortalUrl(
                application.getInitParameter(IdentityManagementEndpointConstants.ConfigConstants.USER_PORTAL_URL)))%>";
        })
    });
</script>
</body>
</html>
