<main>
  <div class="layout_topBar">
    <div class="layout_container flex flex-jc:space-between flex-ai:center">
      <a href="./index.php?p=home" class="layout_topBar_logo">
        <img src="images/{$logo}" alt="SourceBans 标志" />
      </a>

      <div class="layout_topBar_search responsive_show:desktop">
        {literal}
          <form method="get" action="index.php">
            <input type="hidden" name="p" value="banlist" />
            <input class="searchbox" alt="搜索封禁" name="searchText" type="text" onfocus="this.value='';" onblur="if (this.value=='') {this.value=' 搜索封禁...';}" value=" 搜索封禁..." />
            <input class="button_search" type="submit" name="Submit" value="搜索" />
          </form>

          <form method="get" action="index.php">
            <input type="hidden" name="p" value="commslist" />
            <input class="searchbox" alt="搜索禁言" name="searchText" type="text" onfocus="this.value='';" onblur="if (this.value=='') {this.value=' 搜索禁言...';}" value=" 搜索禁言... " />
            <input class="button_search" type="submit" name="Submit" value="搜索" />
          </form>
        {/literal}
      </div>

      <ul class="SocialMedia layout_topBar_action flex flex-ai:center">
        <li>
          <button id="user_action_change_dark" aria-label="深色模式"><i class="fas fa-moon"></i></button>
        </li>
        <li class="jscolor_li">
          <button data-jscolor aria-label="颜色"></button>
        </li>
        <li id="jscolor_reset" class="jscolor_li" style="display: none;">
          <button aria-label="重置颜色"><i class="fa fa-refresh"></i></button>
        </li>

        <li class="responsive_show:desktop">
          <a target="_blank" href="https://github.com/WenYin-Community/" rel="noopener" title="文印社区">
            <i class="fa-brands fa-github fa-lg"></i>
          </a>
        </li>
      </ul>

      <ul class="layout_topBar_userBar responsive_show:desktop flex flex-ai:center">
        {if $login}
          <li class="margin-right:half">
            欢迎，<a href='index.php?p=account'><i class="fas fa-user"></i> {$username}</a>
          </li>
          <li>
            <a class="button button-logout" href='index.php?p=logout'><i class="fas fa-sign-out-alt"></i>
              退出登录</a>
          </li>
        {else}
          <li>
            <a class="button button-login" href='index.php?p=login'>登录</a>
          </li>
        {/if}
      </ul>

      <button id="button_mobile_open" class="nav_mobile_open responsive_hide:desktop" aria-label="移动导航打开">
        <i class="fas fa-bars"></i>
      </button>
    </div>
  </div>

  <div id="layout_mobile" class="nav_mobile">
    <button id="button_mobile_close" class="nav_mobile_close" aria-label="移动导航关闭">
      <i class="fas fa-times"></i>
    </button>
    <div class="nav_mobile_content">

      <div class="nav_mobile_tab_top padding flex">
        {if $login}
          <a class="button button-important button:full" href='index.php?p=logout'><i class="fas fa-sign-out-alt"></i>
            退出登录</a>
        {else}
          <a class="button button-success" href='index.php?p=login'>登录</a>
        {/if}
      </div>
      <nav class="nav_mobile_tab_nav">
        <ul>
            {foreach from=$navbar item="nav"}
                <li class="{$nav.state}">
                    <a href="index.php?p={$nav.endpoint}" data-nav="{$nav.endpoint}">
                        {$nav.title}
                    </a>
                </li>
            {/foreach}
		    {if $isAdmin}
                {foreach from=$adminbar item="admin"}
			        <li class="{$nav.state}">
				        <a class="nav_link {$admin.state}" href="index.php?p=admin&c={$admin.endpoint}">
					        {$admin.title}
				        </a>
			        </li>
                {/foreach}
            {/if}
        </ul>
      </nav>

    </div>
    <div class="nav_mobile_background"></div>
  </div>

    <nav id="navBar" class="nav responsive_show:desktop">
        <div class="nav_tab">
            <ul>
                {if $login}
                    <li class="margin-right">
                        <a href='index.php?p=account'><i class="fa-solid fa-gear"></i> 账号信息</a>
                    </li>
                {/if}
                    {foreach from=$navbar item="nav"}
                    <li class="{$nav.state}">
                        <a href="index.php?p={$nav.endpoint}" data-nav="{$nav.endpoint}">
                        {$nav.title}
                        </a>
                    </li>
                    {/foreach}
                {if $isAdmin}
                    {foreach from=$adminbar item="admin"}
                        <li class="{$nav.state}">
                            <a class="nav_link {$admin.state}" href="index.php?p=admin&c={$admin.endpoint}">
                                {$admin.title}
                            </a>
                        </li>
                    {/foreach}
                {/if}
            </ul>
        </div>
  </nav>
  <div id="mainwrapper" class="layout_body flex:11">
