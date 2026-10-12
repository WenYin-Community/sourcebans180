<h2 class="title text-center">选择要管理的选项</h2>
<div class="admin_nav">
    <ul class="flex">
		{if $access_admins}
			 <li>
					<a href="index.php?p=admin&amp;c=admins">
					  <i class="fas fa-user"></i>
					  <span>管理员</span>
				  </a>
			 </li>
    	{/if}
        {if $access_bans}
            <li>
                <a href="index.php?p=admin&amp;c=bans">
                    <i class="fas fa-ban"></i>
                    <span>封禁</span>
                </a>
            </li>
        {/if}
		{if $access_bans}
            <li>
                <a href="index.php?p=admin&amp;c=comms">
                    <i class="fas fa-microphone-alt-slash"></i>
                    <span>语音封禁</span>
                </a>
            </li>
        {/if}
        {if $access_groups}
            <li>
                <a href="index.php?p=admin&amp;c=groups">
                    <i class="fas fa-users"></i>
                    <span>组</span>
                </a>
            </li>
        {/if}
		 {if $access_servers}
            <li>
                <a href="index.php?p=admin&amp;c=servers">
                    <i class="fas fa-server"></i>
                    <span>服务器</span>
                </a>
            </li>
        {/if}
        {if $access_settings}
            <li>
                <a href="index.php?p=admin&amp;c=settings">
                    <i class="fas fa-tools"></i>
                    <span>网页面板</span>
                </a>
            </li>
        {/if}
        {if $access_mods}
            <li>
                <a href="index.php?p=admin&amp;c=mods">
                    <i class="fas fa-cubes"></i>
                    <span>管理模组</span>
                </a>
            </li>
        {/if}
    </ul>
</div>

<div class="admin_dashboard margin-top">
<div class="layout_box">
        <div class="layout_box_title">
            <h2 align="center"><i class="fas fa-ban"></i> 封禁 - 语音封禁</h2>
        </div>
        <div class="padding">
            <ul class="list-reset">
                <!-- WARNING: To fully fix this part use https://github.com/Rushaway/sourcebans-pp/commit/f05a4bcdfa59002970daeb0b8231ffc1b13c834c -->
                <li>总封禁数 : <span class="text:bold">{$total_bans}</span></li>
                <li>总语音封禁数 : <span class="text:bold">{$total_comms}</span></li>
                <li>已阻止连接 : <span class="text:bold">{$total_blocks}</span></li>
            </ul>
        </div>
    </div>


    <div class="layout_box">
        <div class="layout_box_title">
            <h2 align="center"><i class="fas fa-user-shield fa-1x"></i> 管理员信息</h2>
        </div>
        <div class="padding">
		<ul class="list-reset" align="center">
					<li>我们总共有 <span class="text:bold" style="font-size:xx-large"> <i style="color:#dd6b20">{$total_admins}</i></span> 名管理员分布在所有服务器中！</li>
					&nbsp;
					<li><i class="fas fa-rocket fa-1x"></i> 团队合作让<span class="text-primary">梦想成真</span>！</li>
					</ul>
				</div>
    </div>

	<div class="layout_box">
        <div class="layout_box_title">
            <h2 align="center"><i class="fas fa-exclamation-circle"></i> 举报统计</h2>
        </div>
        <div class="padding">
            <ul class="list-reset" align="right">
                <li>待处理 : <span class="text:bold">{$total_submissions}</span></li>
                <li>已归档 : <span class="text:bold">{$archived_submissions}</span></li>
            </ul>
        </div>
    </div>

    <div class="layout_box">
        <div class="layout_box_title">
            <h2 align="center"><i class="fas fa-angry"></i> 申诉统计</h2>
        </div>
        <div class="padding">
            <ul class="list-reset">
                <li>待处理 : <span class="text:bold">{$total_protests}</span></li>
                <li>已归档 : <span class="text:bold">{$archived_protests}</span></li>
            </ul>
        </div>
    </div>

	<div class="layout_box">
        <div class="layout_box_title">
            <h2 align="center"><i class="fas fa-server"></i> 服务器信息</h2>
        </div>
        <div class="padding" align="center">
            <ul class="list-reset">
				<li>我们总共有 <span class="text:bold" style="font-size:x-large"> <i style="color:#dd6b20">{$total_servers}</i></span> 台服务器注册在 SourceBans。</li>
				<li>总演示文件大小为 <span class="text:bold" style="font-size:x-large"> <i style="color:#dd6b20">{$demosize}</i></span> 托管在我们的 Web 服务器上。</li>
            </ul>
        </div>
    </div>

    <div class="layout_box">
        <div class="layout_box_title">
            <h2 align="center"><i class="fas fa-code-branch"></i> 版本信息</h2>
        </div>
        <div class="padding" align="right">
            <ul class="list-reset">
                <li>最新版本: <span id='relver' class="text:bold">请稍候...</span></li>
                {if $dev}
                    <li>最新 Git 版本: <span id='svnrev' class="text:bold">请稍候...</span></li>
                {/if}
                <li><span id='versionmsg'>请稍候...</span></li>
            </ul>
        </div>
    </div>

    <script type="text/javascript">
        xajax_CheckVersion();
    </script>
</div>