{**
 * 2007-2014 PrestaShop
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License (AFL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/afl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@prestashop.com so we can send you a copy immediately.
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade PrestaShop to newer
 * versions in the future. If you wish to customize PrestaShop for your
 * needs please refer to http://www.prestashop.com for more information.
 *
 * @author    EXAPAQ S.A.S. <support@icirelais.com>
 * @copyright 2015 EXAPAQ S.A.S.
 * @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
 *}

<script type="text/javascript">
{literal}

$(document).ready(function(){
	$("a.more").click(function() {
    $.fancybox({
            'padding'       : 0,
            'autoScale'     : false,
            'openEffect'  	: 'elastic',
            'closeEffect' 	: 'elastic',           
			'openSpeed'  	: 150,
            'closeSpeed' 	: 150,
            'title'         : this.title,
            'width'     	: 720,
            'height'        : 435,
            'href'          : this.href.replace(new RegExp("watch\\?v=", "i"), 'v/') + '&autoplay=1',
            'type'          : 'swf',
            'swf'           : {
            'wmode'        	: 'transparent',
            'allowfullscreen'   : 'true'
            }
        });

    return false;
	});
	
	$('#id_carrier' + {/literal}{$predict_carrier_id}{literal}).parent().parent().after("<tr><td colspan='4' style='padding:0; display:none;' id='tr_carrier_exapredict'></td></tr>");
	
	exapredictresponse = $('#div_exapredict_block');

	if ($('#id_carrier' + {/literal}{$predict_carrier_id}{literal}).attr('checked')){
		document.getElementById('div_exapredict_block').style.display = "";
		$("#tr_carrier_exapredict").html(exapredictresponse);
		$("#tr_carrier_exapredict").fadeIn('slow');
	}		
					
	$('#id_carrier' + {/literal}{$predict_carrier_id}{literal}).click(function(){
		document.getElementById('div_exapredict_block').style.display = "";
		$("#tr_carrier_exapredict").html(exapredictresponse);
		$("#tr_carrier_exapredict").fadeIn('slow');
	});
					
	$("input[name='id_carrier']").change(function(){
		if (!$('#id_carrier' + {/literal}{$predict_carrier_id}{literal}).attr('checked')){
			$("#tr_carrier_exapredict").fadeOut('fast');
		}
	});
});

{/literal}
</script>

<td colspan="4" id="div_exapredict_block" style="	display:none;
													position: static; 
													width: 100; 
													height: auto;
													background-color: #f0f0f0;
													padding: 0;
													font-size:12px;
													font-family: Arial;">
		
	<div id="div_exapredict_header" style="	background-color: #ffffff;
											color: #ffffff;
											font-size: 12px;
											width: 100%;
											height: 24px;
											line-height: 24px;
											font-weight: normal;">
	
		<p style="	margin: 0;
					padding: 0;
					padding-left: 5px;
					height: 23px;
					width: 100%;
					background-color: #fff;
					border-bottom: 0px solid #E3002A;
					color: #666;
					font-size: 14px;
					font-weight: normal;
					font-family: Arial;">
		{l s='Your order will be delivered by EXAPAQ with Predict service' mod='exapaq'}
		</p>
	</div>

	<div id="div_exapredict_logo" style="	width: 100%;
											height: 64px;
											padding:0px;
											background: #f0f0f0 url({if $ssl}{$base_dir_ssl|escape:'htmlall':'UTF-8'}{else}{$base_dir|escape:'htmlall':'UTF-8'}{/if}modules/exapaq/views/img/front/predict/exapaq_logo.png) no-repeat center;">
	</div>
	
	<div id="div_exapredict_text">
		<h style="font-weight:bold; padding-left:10px;">{l s='Discover EXAPAQ\'s Predict service :' mod='exapaq'}
			<br/></h>
		
		<div id="div_exapredict_sms" style="    height: 64px;
												width: 100%;
												display:block;
												margin:10px;">
			<div id="icon_exapredict_sms" style="   height: 64px;
													width: 64px;
													background: transparent url({if $ssl}{$base_dir_ssl|escape:'htmlall':'UTF-8'}{else}{$base_dir|escape:'htmlall':'UTF-8'}{/if}modules/exapaq/views/img/front/predict/sms.png) no-repeat center;
													display : inline-block;
													float:left;"></div>
			<div id="text_exapredict_sms" style="   height: 46px;
													width: 400px;
													margin-left: 10px;
													display: inline-block;
													float:left;
													padding-top : 8px;
													padding-bottom: 8px;">
			{l s='Once your order is shipped, we will send you a text asking you to choose a day and a time window for your delivery. ' mod='exapaq'}</div>
		</div>
		
		<div id="div_exapredict_calendar" style="	height: 64px;
													width: 100%;
													display:block;
													margin:10px;">
			<div id="icon_exapredict_calendar" style="	height: 64px;
														width: 64px;
														background: transparent url({if $ssl}{$base_dir_ssl|escape:'htmlall':'UTF-8'}{else}{$base_dir|escape:'htmlall':'UTF-8'}{/if}modules/exapaq/views/img/front/predict/calendar.png) no-repeat center;
														display : inline-block;
														float:left;">
			</div>
			<div id="text_exapredict_calendar" style="	height: 48px;
														width: 400px;
														margin-left : 10px;
														display : inline-block;
														float:left;
														padding-top : 6px;
														padding-bottom: 6px;">
			{l s='If the initial delivery date is not convenient, you will be able to rearrange your delivery by texting us* or through our website ' mod='exapaq'}<a target="_blank" href="http://www.exapaq.com"> www.exapaq.com</a>
			</div>
		</div>
		
		<div id="div_exapredict_time" style="	height: 64px;
												width: 100%;
												display:block;
												margin:10px;">
			<div id="icon_exapredict_time" style="	height: 64px;
													width: 64px;
													background: transparent url({if $ssl}{$base_dir_ssl|escape:'htmlall':'UTF-8'}{else}{$base_dir|escape:'htmlall':'UTF-8'}{/if}modules/exapaq/views/img/front/predict/time.png) no-repeat center;
													display : inline-block;
													float:left;">
			</div>
			<div id="text_exapredict_time" style="	height: 60px;
													width: 400px;
													margin-left : 10px;
													display : inline-block;
													float:left;
													padding-top : 2px;
													padding-bottom: 2px;">
			{l s='The day your order is out for delivery, a text will remind you the selected time window. In case of absence, you can organize a new delivery at a later date, another address, or retrieve your parcel in one of our 5000 ICI relais points.' mod='exapaq'}
			</div>
		</div>
	</div>
	
	<div id="div_exapredict_gsm" style="	width: auto; 
											padding-bottom:10px; 
											font-weight:bold;">
		<form method='post' action='{if $ssl}{$base_dir_ssl|escape:'htmlall':'UTF-8'}{else}{$base_dir|escape:'htmlall':'UTF-8'}{/if}modules/exapaq/validation.php' style="    
																					line-height: 18px;
																					height: 16px;
																					width: auto;
																					display: inline-block;">
			<p>
			{l s='Get all the advantages of EXAPAQ\'s Predict service by providing a french GSM number here and click on the icon to confirm ' mod='exapaq'}

			<input type='text' name="exapredict_gsm_dest" id="input_exapredict_gsm_dest" value="{$exapredict_gsm_dest|escape:'htmlall':'UTF-8'}" style="    width: 90px;
	border-style: solid;
    border-color: #999;
    border-width: 1px;
	font-weight:normal;"></input>
			<input type="submit" value="{$exapredict_gsm_dest|escape:'htmlall':'UTF-8'}" class="exapredict_gsm_submit" onMouseOver="javascript:this.style.cursor='pointer';" onMouseOut="javascript:this.style.cursor='auto';" style="
					width:16px; 
					height:16px; 
					padding-top: 10px;
					margin: 0;
					border: none; 
					background: transparent url({if $ssl}{$base_dir_ssl|escape:'htmlall':'UTF-8'}{else}{$base_dir|escape:'htmlall':'UTF-8'}{/if}modules/exapaq/views/img/front/predict/button_arrow_red.gif) no-repeat center;
					font-size: 0;
					line-height: 0;
					overflow:hidden;
					text-indent: -999px; 
					display:inline-block;"></input>
			</p>
		</form>
	</div>
	<br/>
	
	{if $predict_status == 'error'}
		<div class="predict_error">{l s='It seems that the GSM number you provided is incorrect. Please provide a french GSM number, starting with 06 or 07, on 10 consecutive digits.' mod='exapaq'}</div>
	{/if}

	<br/>
		<i style="font-size:9px;">{l s='* Standard text messaging rates apply.' mod='exapaq'} {l s='Get more info in this video ' mod='exapaq'} <a class="more" href="https://www.youtube.com/watch?v=vLHThZDE8Ac"><img style="    display:inline-block; height: 13px;
    width: 16px;
	border-style:none;
    background: transparent url({if $ssl}{$base_dir_ssl|escape:'htmlall':'UTF-8'}{else}{$base_dir|escape:'htmlall':'UTF-8'}{/if}modules/exapaq/views/img/front/predict/video.png) no-repeat center;"/></a></i>
</td>