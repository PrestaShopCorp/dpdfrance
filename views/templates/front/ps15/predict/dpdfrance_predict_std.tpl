{**
 * 2007-2015 PrestaShop
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
 * @author    DPD S.A.S. <ensavoirplus.ecommerce@dpd.fr>
 * @copyright 2015 DPD S.A.S.
 * @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
 *}

<script type="text/javascript">
var dpdfrancePredictCarrierId = "{$dpdfrance_predict_carrier_id|escape:'javascript':'UTF-8'}";
{literal}

function dpdfrance_predict_redirect(){
	checkedCarrier = $("input[name*='delivery_option[']:checked").val().substr(0,$("input[name*='delivery_option[']:checked").val().indexOf(','));
	if (checkedCarrier != dpdfrancePredictCarrierId) {
		$('#form').attr("action", baseDir+'index.php?controller=order');
		$("#tr_carrier_predict").fadeOut('fast');
		if (document.getElementById("tr_carrier_predict"))
			$("#tr_carrier_predict").remove();
		$("#dpdfrance_predict_container").remove();
	} else {
		$('#form').attr("action", baseDir+'modules/dpdfrance/validation.php?dpdfrance_carrier=' + checkedCarrier);
		if (document.getElementById("div_dpdfrance_predict_block"))
			document.getElementById('div_dpdfrance_predict_block').style.display = "";
		$("#tr_carrier_predict").html(dpdfrance_predict_response);
		$("#tr_carrier_predict").fadeIn('fast');
	}
}

$(document).ready(function() {
	$("a.dpdfrance_more").click(function() {
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
            'allowfullscreen': 'true'
            }
        });

    return false;
});
	carrier_block = $('input[class=delivery_option_radio]:checked').parents('div.delivery_option');
	$(carrier_block).append(
		'<div>'
			+'<table id="dpdfrance_predict_container" class="dpdfrance_predict_container">'
				+'<tr>'
				+	  '<td style="display:none;" id="id_carrier' + dpdfrancePredictCarrierId + '" value="'+dpdfrancePredictCarrierId+'" /></td>'
				+ '</tr>'
			+'</table>'
		+'</div>');
	
	$('#id_carrier' + {/literal}{$dpdfrance_predict_carrier_id|escape:'javascript':'UTF-8'}{literal}).parent().parent().after("<tr><td colspan='4' style='padding:0; display:none;' id='tr_carrier_predict'></td></tr>");

	dpdfrance_predict_response = $('#div_dpdfrance_predict_block');
	
	$("input[name*='delivery_option[']").change(function() {
			dpdfrance_predict_redirect();
		});
		dpdfrance_predict_redirect();
       });
	   
{/literal}
</script>

<div id="div_dpdfrance_predict_block">
	<div id="div_dpdfrance_predict_header"><p>{l s='Your order will be delivered by DPD with Predict service' mod='dpdfrance'}</p></div>
	<div class="module" id="predict">
		<div id="div_dpdfrance_predict_logo"></div>
		<div class="copy"> 
			<p><h2>{l s='Predict offers you the following benefits' mod='dpdfrance'} :</h2></p>
			<ul>
				<li><b>{l s='A parcel delivery in a 3-hour time window (choice is made by SMS or through our website)' mod='dpdfrance'}</b></li>
				<li><b>{l s='A complete and detailed tracking of your delivery' mod='dpdfrance'}</b></li>
				<li><b>{l s='In case of absence, you can schedule a new delivery when and where you it suits you best' mod='dpdfrance'}</b></li>
			</ul>
			<br/>
			<p><h2>{l s='How does it work?' mod='dpdfrance'}</h2></p>
			<ul>
				<li>{l s='Once your order is ready for shipment, you will receive an SMS proposing various days and time windows for your delivery.' mod='dpdfrance'}</li>
				<li>{l s='You choose the moment which suits you best for the delivery by replying to the SMS (no extra cost) or through our website' mod='dpdfrance'} <a href="http://www.dpd.fr/destinataires">dpd.fr</a></li>
				<li>{l s='On the day of delivery, a text message will remind you the selected time window.' mod='dpdfrance'}</li>
			</ul>
		</div>
		<br/>
		<div id="div_dpdfrance_dpd_logo"></div>
	</div>

	{if $dpdfrance_predict_status == 'error'}
		<div class="warnmsg">{l s='It seems that the GSM number you provided is incorrect. Please provide a french GSM number, starting with 06 or 07, on 10 consecutive digits.' mod='dpdfrance'}</div>
	{/if}

	<div id="div_dpdfrance_predict_gsm">
		{l s='Get all the advantages of DPD\'s Predict service by providing a french GSM number here ' mod='dpdfrance'} 
		<input type='text' name="dpdfrance_predict_gsm_dest" id="input_dpdfrance_predict_gsm_dest" value="{$dpdfrance_predict_gsm_dest|escape:'htmlall':'UTF-8'}"></input><div id="dpdfrance_predict_gsm_button" onclick="$(&quot;[name='processCarrier']&quot;).click();">></div>
	</div>
</div>