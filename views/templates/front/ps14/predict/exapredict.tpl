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
var predictCarrierId = "{$predict_carrier_id|escape:'htmlall':'UTF-8'}";
{literal}

function predict_redirect() {
	checkedCarrier = $("input[name*='id_carrier']:checked").val();
	if (checkedCarrier != predictCarrierId) {
		$("#form").attr("action", baseDir+'order.php');
		$("#tr_carrier_exapredict").fadeOut('fast');
	} else {
		$("#form").attr("action", baseDir+'modules/exapaq/validation.php?exa_carrier=' + checkedCarrier);
		if (document.getElementById("div_exapredict_block"))
			document.getElementById('div_exapredict_block').style.display = "";
		$("#tr_carrier_exapredict").html(exapredictresponse);
		$("#tr_carrier_exapredict").fadeIn('fast');
	}
}

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
	checkedCarrier = $("input[name*='id_carrier']:checked").val();

	if ($('#id_carrier' + {/literal}{$predict_carrier_id}{literal}).attr('checked')){
		document.getElementById('div_exapredict_block').style.display = "";
		$("#form").attr("action", baseDir+'modules/exapaq/validation.php?exa_carrier=' + checkedCarrier);
		$("#tr_carrier_exapredict").html(exapredictresponse);
		$("#tr_carrier_exapredict").fadeIn('slow');
	}		
					
	$('#id_carrier' + {/literal}{$predict_carrier_id}{literal}).click(function(){
		document.getElementById('div_exapredict_block').style.display = "";
		$("#form").attr("action", baseDir+'modules/exapaq/validation.php?exa_carrier=' + checkedCarrier);
		$("#tr_carrier_exapredict").html(exapredictresponse);
		$("#tr_carrier_exapredict").fadeIn('slow');
	});
					
	$("input[name='id_carrier']").change(function(){
		checkedCarrier = $("input[name*='id_carrier']:checked").val();
		if (!$('#id_carrier' + {/literal}{$predict_carrier_id}{literal}).attr('checked')){
			$("#tr_carrier_exapredict").fadeOut('fast');
			$("#form").attr("action", baseDir+'order.php');
		}
	});
});

{/literal}
</script>

<div id="div_exapredict_block" style="display:none;">
	<div id="div_exapredict_header"><p>{l s='Your order will be delivered by EXAPAQ with Predict service' mod='exapaq'}</p></div>
	<div id="div_exapredict_logo"></div>
	<div id="div_exapredict_text">
		<h>{l s='Discover EXAPAQ\'s Predict service :' mod='exapaq'}
			<br/></h>
		
		<div id="div_exapredict_sms">
			<div id="icon_exapredict_sms"></div>
			<div id="text_exapredict_sms">{l s='Once your order is shipped, we will send you a text asking you to choose a day and a time window for your delivery. ' mod='exapaq'}</div>
		</div>
		
		<div id="div_exapredict_calendar">
			<div id="icon_exapredict_calendar"></div>
			<div id="text_exapredict_calendar">{l s='If the initial delivery date is not convenient, you will be able to rearrange your delivery by texting us* or through our website ' mod='exapaq'}<a target="_blank" href="http://www.exapaq.com"> www.exapaq.com</a></div>
		</div>
		
		<div id="div_exapredict_calendar">
			<div id="icon_exapredict_time"></div>
			<div id="text_exapredict_time">{l s='The day your order is out for delivery, a text will remind you the selected time window. In case of absence, you can organize a new delivery at a later date, another address, or retrieve your parcel in one of our 5000 ICI relais points.' mod='exapaq'}</div>
		</div>
	</div>
	
	<div id="div_exapredict_gsm">
		<p>
		{l s='Get all the advantages of EXAPAQ\'s Predict service by providing a french GSM number here ' mod='exapaq'}
			<input type='text' name="exapredict_gsm_dest" id="input_exapredict_gsm_dest" value="{$exapredict_gsm_dest|escape:'htmlall':'UTF-8'}"></input>
		</p>
	</div>

	{if $predict_status == 'error'}
	<div class="predict_error">{l s='It seems that the GSM number you provided is incorrect. Please provide a french GSM number, starting with 06 or 07, on 10 consecutive digits.' mod='exapaq'}</div>
	{/if}

	<br/>
	<i style="font-size:9px;">{l s='* Standard text messaging rates apply.' mod='exapaq'} {l s='Get more info in this video ' mod='exapaq'} <a class="more" href="https://www.youtube.com/watch?v=vLHThZDE8Ac"><img/></a></i>
</div>