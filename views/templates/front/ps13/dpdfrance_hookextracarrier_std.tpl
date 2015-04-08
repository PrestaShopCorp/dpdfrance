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
 * @author    DPD S.A.S. <ensavoirplus.ecommerce@dpd.fr>
 * @copyright 2015 DPD S.A.S.
 * @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
 *}

<link rel="stylesheet" type="text/css" href="{if $ssl}{$base_dir_ssl|escape:'javascript':'UTF-8'}{else}{$base_dir|escape:'javascript':'UTF-8'}{/if}modules/dpdfrance/views/css/front/dpdfrance.css"/>
<script type="text/javascript" src="{if $ssl}{$base_dir_ssl|escape:'javascript':'UTF-8'}{else}{$base_dir|escape:'javascript':'UTF-8'}{/if}modules/dpdfrance/views/js/front/relais/dpdfrance_relais.js"></script>
<script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=false"></script>
<script type="text/javascript">
{literal}
	
$(document).ready(function(){

	$('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).parent().parent().after("<tr><td colspan='4' style='height:340px;vertical-align:top;padding:0; display:none' id='tr_carrier_dpdfrance_relais'></td></tr>");
	dpdfrance_relais_response = $('#dpdfrance_relais_point_table');
	checkedCarrier = $("input[name*='id_carrier']:checked").val();
	if ($("#div_dpdfrance_relais_error").length==0){
		if ($('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked')){
			document.getElementById('dpdfrance_relais_point_table').style.display = "";
			$("#form").attr("action", baseDir+'modules/dpdfrance/validation.php?dpdfrance_carrier=' + checkedCarrier);
			$("#tr_carrier_dpdfrance_relais").html(dpdfrance_relais_response);
			$("#tr_carrier_dpdfrance_relais").fadeIn('slow');
		}
		
		$('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).click(function(){
			document.getElementById('dpdfrance_relais_point_table').style.display = "";
			$("#form").attr("action", baseDir+'modules/dpdfrance/validation.php?dpdfrance_carrier=' + checkedCarrier);
			$("#tr_carrier_dpdfrance_relais").html(dpdfrance_relais_response);
			$("#tr_carrier_dpdfrance_relais").fadeIn('slow');
		});
						
		$("input[name='id_carrier']").change(function(){
			checkedCarrier = $("input[name*='id_carrier']:checked").val();
			if (!$('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked')){
				$("#tr_carrier_dpdfrance_relais").fadeOut('fast');
				$("#form").attr("action", baseDir+'order.php');
			}
		});
	}
	else
	{
		if ($('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked')){
			$("#div_dpdfrance_relais_error").fadeIn('slow');
			$("#form").attr("action", baseDir+'modules/dpdfrance/validation.php?dpdfrance_carrier=' + checkedCarrier);
		}

		$('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).click(function(){
			$("#div_dpdfrance_relais_error").fadeIn('slow');
			$("#form").attr("action", baseDir+'modules/dpdfrance/validation.php?dpdfrance_carrier=' + checkedCarrier);			
		});

		$("input[name='id_carrier']").change(function(){
			if (!$('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked')){
				$("#div_dpdfrance_relais_error").fadeOut('fast');
				$("#form").attr("action", baseDir+'order.php');
			}
		});
	}
});

{/literal}
</script>

<div id="dpdfrance_relais_filter" onclick="{literal}
	var i = 1;
	for (i=1; i<6; i++){
		document.getElementById('dpdfrance_relais_filter').style.display='none';
		document.getElementById('relaydetail'+i).style.display='none';
	}{/literal}">
</div>

{if isset($error)}
	<tr>
		<td colspan="5" id="div_dpdfrance_relais_error" style="display:none;"><div class="alert warning"> {$error|escape:'htmlall':'UTF-8'} </div></td>
	</tr>
{else}

<table align="center" width="100%" id="dpdfrance_relais_point_table" class="dpdfrance_relaistable" style="display:none;">
	<td colspan="5" id="dpdfrance_div_relais_header" width="100%"><p>{l s='Please select your DPD Relais parcelshop among this list' mod='dpdfrance'}</p></td>

{foreach from=$dpdfrance_relais_points item=points name=dpdfranceRelaisLoop} 
<tr class="dpdfrance_lignepr" onclick="document.getElementById('{$points.relay_id|escape:'htmlall':'UTF-8'}').checked=true">
		<td align="left" class="dpdfrance_logorelais"></td>
		<td align="left" class="dpdfrance_adressepr"><b>{$points.shop_name|escape:'htmlall':'UTF-8'}</b><br/>{$points.address1|escape:'htmlall':'UTF-8'}<br/>{$points.postal_code|escape:'htmlall':'UTF-8'} {$points.city|escape:'htmlall':'UTF-8'}<br/></td>
		<td align="right" class="dpdfrance_distancepr">{$points.distance|escape:'htmlall':'UTF-8'} km</td>
		<td align="center" class="dpdfrance_popinpr">
			<span onMouseOver="javascript:this.style.cursor='pointer';" onMouseOut="javascript:this.style.cursor='auto';"
				onClick="openDpdfranceDialog('relaydetail{$smarty.foreach.dpdfranceRelaisLoop.index+1|escape:'htmlall':'UTF-8'}','map_canvas{$smarty.foreach.dpdfranceRelaisLoop.index+1|escape:'htmlall':'UTF-8'}',{$points.coord_lat|escape:'htmlall':'UTF-8'},{$points.coord_long|escape:'htmlall':'UTF-8'},'{if $ssl}{$base_dir_ssl|escape:'htmlall':'UTF-8'}{else}{$base_dir|escape:'htmlall':'UTF-8'}{/if}')">
				<u>{l s='More details' mod='dpdfrance'}</u>
			</span>
		</td>
		<td align="center" class="dpdfrance_radiopr">
			<p class="radio-group">
			{if $selectedrelay == $points.relay_id}
				<input type="radio" name="dpdfrance_relay_id" id="{$points.relay_id|escape:'htmlall':'UTF-8'}" value="{$points.relay_id|escape:'htmlall':'UTF-8'}" checked="checked">
			{else}
				<input type="radio" name="dpdfrance_relay_id" id="{$points.relay_id|escape:'htmlall':'UTF-8'}" value="{$points.relay_id|escape:'htmlall':'UTF-8'}" {if $smarty.foreach.dpdfranceRelaisLoop.first} checked="checked" {/if}>
			{/if}
				<label for="{$points.relay_id|escape:'htmlall':'UTF-8'}"><span><span></span></span><b>ICI</b></label>
			</p>
		</td>
</tr>	

<div id="relaydetail{$smarty.foreach.dpdfranceRelaisLoop.index+1|escape:'htmlall':'UTF-8'}" class="dpdfrance_relaisbox" style="display:none;">

	<div class="dpdfrance_relaisboxclose" onclick="
		document.getElementById('relaydetail{$smarty.foreach.dpdfranceRelaisLoop.index+1|escape:'htmlall':'UTF-8'}').style.display='none';
		document.getElementById('dpdfrance_relais_filter').style.display='none';
		$('#header').css('z-index',10);">
		<img src="{if $ssl}{$base_dir_ssl|escape:'htmlall':'UTF-8'}{else}{$base_dir|escape:'htmlall':'UTF-8'}{/if}modules/dpdfrance/views/img/front/relais/box-close.png"/>
	</div>
	
	<div class="dpdfrance_relaisboxcarto" id="map_canvas{$smarty.foreach.dpdfranceRelaisLoop.index+1|escape:'htmlall':'UTF-8'}"></div>

	<div id="relaisboxbottom" class="dpdfrance_relaisboxbottom">
		<div id="relaisboxadresse" class="dpdfrance_relaisboxadresse">
		<div class="dpdfrance_relaisboxadresseheader">{l s='Your DPD Pickup point' mod='dpdfrance'}</div><br/>
			<b>{$points.shop_name|escape:'htmlall':'UTF-8'}</b><br/>
			{$points.address1|escape:'htmlall':'UTF-8'}<br/>
			{if isset($points.address2)}
				{$points.address2|escape:'htmlall':'UTF-8'}<br/>
			{/if}
			{$points.postal_code|escape:'htmlall':'UTF-8'} {$points.city|escape:'htmlall':'UTF-8'}<br/>
			{if isset($points.local_hint)}
				<p>{l s='Landmark' mod='dpdfrance'} : {$points.local_hint|escape:'htmlall':'UTF-8'}</p>
			{/if}
		</div>

		<div class="dpdfrance_relaisboxhoraires">
			<div class="dpdfrance_relaisboxhorairesheader">{l s='Opening hours' mod='dpdfrance'}</div><br/>
				<p>
					<span class="dpdfrance_relaisboxjour">{l s='Monday' mod='dpdfrance'} : </span>
					{if !isset($points.monday)} {l s='Closed' mod='dpdfrance'} 
					{else}
						{if $points.monday[0]}
							{$points.monday[0]|escape:'htmlall':'UTF-8'} 
							{if isset($points.monday[1])}
								& {$points.monday[1]|escape:'htmlall':'UTF-8'}
							{/if}
						{/if}
					{/if}
				</p>
				
				<p>
					<span class="dpdfrance_relaisboxjour">{l s='Tuesday' mod='dpdfrance'} : </span>
					{if !isset($points.tuesday)} {l s='Closed' mod='dpdfrance'} 
					{else}
						{if $points.tuesday[0]}
							{$points.tuesday[0]|escape:'htmlall':'UTF-8'} 
							{if isset($points.tuesday[1])}
								& {$points.tuesday[1]|escape:'htmlall':'UTF-8'}
							{/if}
						{/if}
					{/if}
				</p>
				
				<p>
					<span class="dpdfrance_relaisboxjour">{l s='Wednesday' mod='dpdfrance'} : </span>
					{if !isset($points.wednesday)} {l s='Closed' mod='dpdfrance'} 
					{else}
						{if $points.wednesday[0]}
							{$points.wednesday[0]|escape:'htmlall':'UTF-8'} 
							{if isset($points.wednesday[1])}
								& {$points.wednesday[1]|escape:'htmlall':'UTF-8'}
							{/if}
						{/if}
					{/if}
				</p>
				
				<p>
					<span class="dpdfrance_relaisboxjour">{l s='Thursday' mod='dpdfrance'} : </span>
					{if !isset($points.thursday)} {l s='Closed' mod='dpdfrance'} 
					{else}
						{if $points.thursday[0]}
							{$points.thursday[0]|escape:'htmlall':'UTF-8'} 
							{if isset($points.thursday[1])}
								& {$points.thursday[1]|escape:'htmlall':'UTF-8'}
							{/if}
						{/if}
					{/if}
				</p>
				
				<p>
					<span class="dpdfrance_relaisboxjour">{l s='Friday' mod='dpdfrance'} : </span>
					{if !isset($points.friday)} {l s='Closed' mod='dpdfrance'} 
					{else}
						{if $points.friday[0]}
							{$points.friday[0]|escape:'htmlall':'UTF-8'} 
							{if isset($points.friday[1])}
								& {$points.friday[1]|escape:'htmlall':'UTF-8'}
							{/if}
						{/if}
					{/if}
				</p>
				
				<p>
					<span class="dpdfrance_relaisboxjour">{l s='Saturday' mod='dpdfrance'} : </span>
					{if !isset($points.saturday)} {l s='Closed' mod='dpdfrance'} 
					{else}
						{if $points.saturday[0]}
							{$points.saturday[0]|escape:'htmlall':'UTF-8'} 
							{if isset($points.saturday[1])}
								& {$points.saturday[1]|escape:'htmlall':'UTF-8'}
							{/if}
						{/if}
					{/if}
				</p>
				
				<p>
					<span class="dpdfrance_relaisboxjour">{l s='Sunday' mod='dpdfrance'} : </span>
					{if !isset($points.sunday)} {l s='Closed' mod='dpdfrance'} 
					{else}
						{if $points.sunday[0]}
							{$points.sunday[0]|escape:'htmlall':'UTF-8'} 
							{if isset($points.sunday[1])}
								& {$points.sunday[1]|escape:'htmlall':'UTF-8'}
							{/if}
						{/if}
					{/if}
				</p>
			</div>

			<div id="relaisboxinfos" class="dpdfrance_relaisboxinfos">
				<div class="dpdfrance_relaisboxinfosheader">{l s='More info' mod='dpdfrance'}</div><br/>
				<h5>{l s='Distance in km' mod='dpdfrance'} : </h5>{$points.distance|escape:'htmlall':'UTF-8'} km <br/>
				<h5>{l s='DPD Relais code' mod='dpdfrance'} : </h5>{$points.relay_id|escape:'htmlall':'UTF-8'} <br/>
				{if isset($points.closing_period[0])}
					<h4><img src="{if $ssl}{$base_dir_ssl|escape:'htmlall':'UTF-8'}{else}{$base_dir|escape:'htmlall':'UTF-8'}{/if}modules/dpdfrance/views/img/front/relais/warning.png"/> {l s='Closing period' mod='dpdfrance'} : </h4>{$points.closing_period[0]|escape:'htmlall':'UTF-8'} <br/>
				{/if}
				{if isset($points.closing_period[1])}
					<h4></h4>{$points.closing_period[1]|escape:'htmlall':'UTF-8'} <br/>
				{/if}
				{if isset($points.closing_period[2])}
					<h4></h4>{$points.closing_period[2]|escape:'htmlall':'UTF-8'} <br/>
				{/if}
			</div>
		</div>
	</div>
{/foreach}

{/if}
</div>
</table>



<script type="text/javascript">
{literal}

$(document).ready(function(){

	$('#id_carrier' + {/literal}{$dpdfrance_predict_carrier_id|escape:'javascript':'UTF-8'}{literal}).parent().parent().after("<tr><td colspan='4' style='padding:0; display:none;' id='tr_carrier_predict'></td></tr>");
	dpdfrance_predict_response = $('#div_dpdfrance_predict_block');
	checkedCarrier = $("input[name*='id_carrier']:checked").val();

	if ($('#id_carrier' + {/literal}{$dpdfrance_predict_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked')){
		document.getElementById('div_dpdfrance_predict_block').style.display = "";
		$("#form").attr("action", baseDir+'modules/dpdfrance/validation.php?dpdfrance_carrier=' + checkedCarrier);
		$("#tr_carrier_predict").html(dpdfrance_predict_response);
		$("#tr_carrier_predict").fadeIn('slow');
	}		
					
	$('#id_carrier' + {/literal}{$dpdfrance_predict_carrier_id|escape:'javascript':'UTF-8'}{literal}).click(function(){
		document.getElementById('div_dpdfrance_predict_block').style.display = "";
		$("#form").attr("action", baseDir+'modules/dpdfrance/validation.php?dpdfrance_carrier=' + checkedCarrier);
		$("#tr_carrier_predict").html(dpdfrance_predict_response);
		$("#tr_carrier_predict").fadeIn('slow');
	});
					
	$("input[name='id_carrier']").change(function(){
		checkedCarrier = $("input[name*='id_carrier']:checked").val();
		if (!$('#id_carrier' + {/literal}{$dpdfrance_predict_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked')){
			$("#tr_carrier_predict").fadeOut('fast');
			$("#form").attr("action", baseDir+'order.php');
		}
	});
});

{/literal}
</script>

<div id="div_dpdfrance_predict_block" style="display:none;">
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