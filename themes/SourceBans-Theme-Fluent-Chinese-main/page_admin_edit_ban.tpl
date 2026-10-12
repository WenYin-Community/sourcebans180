<div id="admin-page-content">
<form action="" method="post">
    <div id="0">
        <div id="msg-green" style="display:none;">
            <i class="fas fa-check fa-2x"></i>
            <b>封禁已更新</b>
            <br />
            封禁详情已更新。<br /><br />
            <i>正在重定向回封禁页面</i>
        </div>
        <div class="admin_tab_content_title">
            <h2><i class="fas fa-user-edit"></i> 封禁详情</h2>
		</div>
		<div class="padding">
            有关更多信息或特定主题的帮助，请将鼠标悬停在问号上。<br /><br />
            <input type="hidden" name="insert_type" value="add">
            <table width="90%" border="0" style="border-collapse:collapse;" id="group.details" cellpadding="3">
                <tr>
                    <td valign="top" width="35%">
                        <div class="rowdesc">
                            -{help_icon title="玩家昵称" message="这是被封禁的玩家名称。"}-玩家昵称
                        </div>
                    </td>
                    <td>
                        <div align="left">
                            <input type="text" class="submit-fields" id="name" name="name" value="-{$ban_name}-" />
                        </div>
                        <div id="name.msg" class="badentry"></div></td>
                    </tr>
                    <tr>
                    <td valign="top" width="35%">
                        <div class="rowdesc">
                            -{help_icon title="封禁类型" message="选择通过 Steam ID 还是 IP 地址进行封禁。"}-封禁类型
                        </div>
                    </td>
                    <td>
                        <div align="left">
                            <select id="type" name="type" TABINDEX=2 class="submit-fields">
                                <option value="0">Steam ID</option>
                                <option value="1">IP 地址</option>
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                        <div class="rowdesc">
                            -{help_icon title="Steam ID" message="这是被封禁玩家的 Steam ID。您也可以输入社区 ID。"}-Steam ID
                        </div>
                    </td>
                <td>
                    <div align="left">
                        <input value="-{$ban_authid}-" type="text" TABINDEX=3 class="submit-fields" id="steam" name="steam" />
                    </div>
                        <div id="steam.msg" class="badentry"></div>
                </td>
                </tr>
                <tr>
                    <td valign="top" width="35%">
                        <div class="rowdesc">
                            -{help_icon title="IP" message="这是被封禁玩家的 IP 地址。"}-IP 地址
                        </div>
                    </td>
                    <td>
                        <div align="left">
                            <input value="-{$ban_ip}-" type="text" TABINDEX=3 class="submit-fields" id="ip" name="ip" />
                        </div>
                        <div id="ip.msg" class="badentry"></div>
                    </td>
                </tr>
                <tr>
                    <td valign="top" width="35%">
                        <div class="rowdesc">
                            -{help_icon title="封禁理由" message="这是封禁该玩家的原因。"}-封禁理由
                        </div>
                    </td>
                    <td>
                        <div align="left">
                            <select id="listReason" name="listReason" TABINDEX=4 class="submit-fields" onChange="changeReason(this[this.selectedIndex].value);">
                                <option value="" selected> -- 选择原因 -- </option>
                                <optgroup label="作弊">
                                    <option value="Aimbot">自瞄</option>
                                    <option value="Antirecoil">防后坐力</option>
                                    <option value="Wallhack">透视</option>
                                    <option value="Spinhack">旋转挂</option>
                                    <option value="Multi-Hack">多功能挂</option>
                                    <option value="No Smoke">去烟雾</option>
                                    <option value="No Flash">去闪光</option>
                                </optgroup>
                                <optgroup label="行为">
                                    <option value="Team Killing">击杀队友</option>
                                    <option value="Team Flashing">闪盲队友</option>
                                    <option value="Spamming Mic/Chat">麦克风/聊天垃圾信息</option>
                                    <option value="Inappropriate Spray">不适当涂鸦</option>
                                    <option value="Inappropriate Language">不当言论</option>
                                    <option value="Inappropriate Name">不当昵称</option>
                                    <option value="Ignoring Admins">无视管理员</option>
                                    <option value="Team Stacking">团队堵路</option>
                                </optgroup>
                                -{if $customreason}-
                                <optgroup label="自定义">
                                    -{foreach from=$customreason item="creason"}-
                                    <option value="-{$creason}-">-{$creason}-</option>
                                    -{/foreach}-
                                </optgroup>
                                -{/if}-
                                <option value="other">其他原因</option>
                            </select>
                            <div id="dreason" style="display:none;">
                                <textarea class="submit-fields" TABINDEX=4 cols="30" rows="5" id="txtReason" name="txtReason"></textarea>
                            </div>
                        </div>
                        <div id="reason.msg" class="badentry"></div>
                    </td>
                </tr>
                <tr>
                    <td valign="top" width="35%">
                        <div class="rowdesc">-{help_icon title="封禁时长" message="选择您要封禁此人的时长。"}-封禁时长 </div>
                    </td>
                    <td>
                        <div align="left">
                            <select id="banlength" name="banlength" TABINDEX=5 class="submit-fields">
                                <option value="0">永久</option>
                                <optgroup label="分钟">
                                    <option value="1">1 分钟</option>
                                    <option value="5">5 分钟</option>
                                    <option value="10">10 分钟</option>
                                    <option value="15">15 分钟</option>
                                    <option value="30">30 分钟</option>
                                    <option value="45">45 分钟</option>
                                </optgroup>
                                <optgroup label="小时">
                                    <option value="60">1 小时</option>
                                    <option value="120">2 小时</option>
                                    <option value="180">3 小时</option>
                                    <option value="240">4 小时</option>
                                    <option value="480">8 小时</option>
                                    <option value="720">12 小时</option>
                                </optgroup>
                                <optgroup label="天">
                                    <option value="1440">1 天</option>
                                    <option value="2880">2 天</option>
                                    <option value="4320">3 天</option>
                                    <option value="5760">4 天</option>
                                    <option value="7200">5 天</option>
                                    <option value="8640">6 天</option>
                                </optgroup>
                                <optgroup label="周">
                                    <option value="10080">1 周</option>
                                    <option value="20160">2 周</option>
                                    <option value="30240">3 周</option>
                                    </optgroup>
                                <optgroup label="月">
                                    <option value="43200">1 月</option>
                                    <option value="86400">2 月</option>
                                    <option value="129600">3 月</option>
                                    <option value="259200">6 月</option>
                                    <option value="518400">12 月</option>
                                </optgroup>
                            </select>
                        </div>
                        <div id="length.msg" class="badentry"></div>
                    </td>
                </tr>
                <tr>
                    <td valign="top" width="35%">
                        <div class="rowdesc">
                            -{help_icon title="上传演示" message="点击此处上传与此封禁提交相关的演示。"}-上传演示
                        </div>
                    </td>
                    <td>
                        <div align="left">
                            -{sb_button text="上传演示" onclick="childWindow=open('pages/admin.uploaddemo.php','upload','resizable=no,width=300,height=130');" class="save" id="uploaddemo" submit=false}-
                        </div>
                        <div id="demo.msg" style="color:#CC0000;">
                            -{$ban_demo}-
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <input type="hidden" name="did" id="did" value="" />
                        <input type="hidden" name="dname" id="dname" value="" />
                        -{sb_button text="保存更改" class="ok" id="editban" submit=true}-
                        -{sb_button text="返回" onclick="history.go(-1)" class="cancel" id="back" submit=false}-
                    </td>
                </tr>
            </table>
            <script type="text/javascript">
                var did = 0;
                var dname = "";
                function demo(id, name)
                {
                    $('demo.msg').setHTML("已上传: <b>" + name + "</b>");
                    $('did').value = id;
                    $('dname').value = name;
                }
            </script>        
        </div>
    </div>
	</from>
</div>