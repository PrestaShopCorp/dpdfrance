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

<link rel="stylesheet" type="text/css" href="{if $ssl}{$base_dir_ssl|escape:'htmlall':'UTF-8'}{else}{$base_dir|escape:'htmlall':'UTF-8'}{/if}modules/exapaq/views/css/front/icirelais/exapaq_icirelais.css"/>
<link rel="stylesheet" type="text/css" href="{if $ssl}{$base_dir_ssl|escape:'htmlall':'UTF-8'}{else}{$base_dir|escape:'htmlall':'UTF-8'}{/if}modules/exapaq/views/css/front/predict/exapaq_predict.css"/>
<script type="text/javascript" src="{if $ssl}{$base_dir_ssl|escape:'htmlall':'UTF-8'}{else}{$base_dir|escape:'htmlall':'UTF-8'}{/if}modules/exapaq/views/js/front/icirelais/exapaq_icirelais.js"></script>
<script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=false"></script>
<script type="text/javascript">
{literal}
	
$(document).ready(function(){

$('#id_carrier' + {/literal}{$icirelais_carrier_id|escape:'htmlall':'UTF-8'}{literal}).parent().parent().after("<tr><td colspan='4' style='padding:0; display:none' id='tr_carrier_icirelais'></td></tr>");
iciresponse = $('#icirelais_point_table');
	
   if ($('#id_carrier' + {/literal}{$icirelais_carrier_id|escape:'htmlall':'UTF-8'}{literal}).attr('checked')){
						document.getElementById('icirelais_point_table').style.display = "";
						document.forms['form'].action = '{/literal}{$urlIci}{literal}';
						$("#tr_carrier_icirelais").html(iciresponse);
						$("#tr_carrier_icirelais").fadeIn('slow');
					}
	
	$('#id_carrier' + {/literal}{$icirelais_carrier_id}{literal}).click(function(){
						document.getElementById('icirelais_point_table').style.display = "";
						document.forms['form'].action = '{/literal}{$urlIci}{literal}';
						$("#tr_carrier_icirelais").html(iciresponse);
						$("#tr_carrier_icirelais").fadeIn('slow');
					});
					
	$("input[name='id_carrier']").change(function(){
		if (!$('#id_carrier' + {/literal}{$icirelais_carrier_id|escape:'htmlall':'UTF-8'}{literal}).attr('checked')){
			$("#tr_carrier_icirelais").fadeOut('fast');
			}
		});
});

{/literal}
</script>

<div id="filter" onclick="{literal}
	var i = 1;
	for (i=1; i<6; i++){
		document.getElementById('filter').style.display='none';
		document.getElementById('relaydetail'+i).style.display='none';
	}{/literal}">
</div>

{if isset($error)}
	<tr>
		<td colspan="5"><div class="alert warning"> {$error|escape:'htmlall':'UTF-8'} </div></td>
	</tr>
{else}

<table align="center" width="100%" id="icirelais_point_table" class="icitable" style="display:none;">
	<td colspan="5" id="div_icirelais_header" width="100%"><p>{l s='Please select your ICI relais parcelshop among this list' mod='exapaq'}</p></td>

{foreach from=$ici_relais_points item=points name=iciLoop} 
<tr class="lignepr" onclick="document.getElementById('{$points.relay_id|escape:'htmlall':'UTF-8'}').checked=true">
		<td align="left" class="logoicirelais"></td>
		<td align="left" class="adressepr"><b>{$points.shop_name|escape:'htmlall':'UTF-8'}</b><br/>{$points.address1|escape:'htmlall':'UTF-8'}<br/>{$points.postal_code|escape:'htmlall':'UTF-8'} {$points.city|escape:'htmlall':'UTF-8'}<br/></td>
		<td align="right" class="distancepr">{$points.distance|escape:'htmlall':'UTF-8'} km</td>
		<td align="center" class="popinpr">
			<span onMouseOver="javascript:this.style.cursor='pointer';" onMouseOut="javascript:this.style.cursor='auto';"
				onClick="openDialog('relaydetail{$smarty.foreach.iciLoop.index+1|escape:'htmlall':'UTF-8'}','map_canvas{$smarty.foreach.iciLoop.index+1|escape:'htmlall':'UTF-8'}',{$points.coord_lat|escape:'htmlall':'UTF-8'},{$points.coord_long|escape:'htmlall':'UTF-8'},'{if $ssl}{$base_dir_ssl|escape:'htmlall':'UTF-8'}{else}{$base_dir|escape:'htmlall':'UTF-8'}{/if}')">
				<u>{l s='More details' mod='exapaq'}</u>
			</span>
		</td>
		<td align="center" class="radiopr">
			<p class="radio-group">
				<input type="radio" name="relay_id" id="{$points.relay_id}" value="{$points.relay_id}" {if $smarty.foreach.iciLoop.first} checked="checked" {/if}>
				<label for="{$points.relay_id|escape:'htmlall':'UTF-8'}"><span><span></span></span><b>ICI</b></label>
			</p>
		</td>
</tr>	

<div id="relaydetail{$smarty.foreach.iciLoop.index+1|escape:'htmlall':'UTF-8'}" class="icirelaisbox" style="display:none;">

	<div class="icirelaisboxclose" onclick="
		document.getElementById('relaydetail{$smarty.foreach.iciLoop.index+1|escape:'htmlall':'UTF-8'}').style.display='none';
		document.getElementById('filter').style.display='none';
		$('#header').css('z-index',10);">
		<img src="{if $ssl}{$base_dir_ssl|escape:'htmlall':'UTF-8'}{else}{$base_dir|escape:'htmlall':'UTF-8'}{/if}modules/exapaq/views/img/front/icirelais/box-close.png"/>
	</div>
	
	<div class="icirelaisboxcarto" id="map_canvas{$smarty.foreach.iciLoop.index+1|escape:'htmlall':'UTF-8'}"></div>

	<div id="icirelaisboxbottom" class="icirelaisboxbottom">
		<div id="icirelaisboxadresse" class="icirelaisboxadresse">
		<div class="icirelaisboxadresseheader">{l s='Your ICI relais point' mod='exapaq'}</div><br/>
			<b>{$points.shop_name|escape:'htmlall':'UTF-8'}</b><br/>
			{$points.address1|escape:'htmlall':'UTF-8'}<br/>
			{if isset($points.address2)}
				{$points.address2|escape:'htmlall':'UTF-8'}<br/>
			{/if}
			{$points.postal_code|escape:'htmlall':'UTF-8'} {$points.city|escape:'htmlall':'UTF-8'}<br/>
			{if isset($points.local_hint)}
				<p>{l s='Landmark' mod='exapaq'} : {$points.local_hint|escape:'htmlall':'UTF-8'}</p>
			{/if}
		</div>

		<div class="icirelaisboxhoraires">
			<div class="icirelaisboxhorairesheader">{l s='Opening hours' mod='exapaq'}</div><br/>
				<p>
					<span class="icirelaisboxjour">{l s='Monday' mod='exapaq'} : </span>
					{if !isset($points.monday)} {l s='Closed' mod='exapaq'} 
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
					<span class="icirelaisboxjour">{l s='Tuesday' mod='exapaq'} : </span>
					{if !isset($points.tuesday)} {l s='Closed' mod='exapaq'} 
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
					<span class="icirelaisboxjour">{l s='Wednesday' mod='exapaq'} : </span>
					{if !isset($points.wednesday)} {l s='Closed' mod='exapaq'} 
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
					<span class="icirelaisboxjour">{l s='Thursday' mod='exapaq'} : </span>
					{if !isset($points.thursday)} {l s='Closed' mod='exapaq'} 
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
					<span class="icirelaisboxjour">{l s='Friday' mod='exapaq'} : </span>
					{if !isset($points.friday)} {l s='Closed' mod='exapaq'} 
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
					<span class="icirelaisboxjour">{l s='Saturday' mod='exapaq'} : </span>
					{if !isset($points.saturday)} {l s='Closed' mod='exapaq'} 
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
					<span class="icirelaisboxjour">{l s='Sunday' mod='exapaq'} : </span>
					{if !isset($points.sunday)} {l s='Closed' mod='exapaq'} 
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

			<div id="icirelaisboxinfos" class="icirelaisboxinfos">
				<div class="icirelaisboxinfosheader">{l s='More info' mod='exapaq'}</div><br/>
				<h5>{l s='Distance in km' mod='exapaq'} : </h5>{$points.distance|escape:'htmlall':'UTF-8'} km <br/>
				<h5>{l s='ICI relais code' mod='exapaq'} : </h5>{$points.relay_id|escape:'htmlall':'UTF-8'} <br/>
				{if isset($points.closing_period[0])}
					<h4><img src="{if $ssl}{$base_dir_ssl|escape:'htmlall':'UTF-8'}{else}{$base_dir|escape:'htmlall':'UTF-8'}{/if}modules/exapaq/views/img/front/icirelais/warning.png"/> {l s='Closing period' mod='exapaq'} : </h4>{$points.closing_period[0]|escape:'htmlall':'UTF-8'} <br/>
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

$('#id_carrier' + {/literal}{$predict_carrier_id}{literal}).parent().parent().after("<tr><td colspan='4' style='padding:0; display:none;' id='tr_carrier_exapredict'></td></tr>");
exapredictresponse = $('#div_exapredict_block');

   if ($('#id_carrier' + {/literal}{$predict_carrier_id}{literal}).attr('checked')){
   						document.getElementById('div_exapredict_block').style.display = "";
						document.forms['form'].action = '{/literal}{$urlExaPredict}{literal}';
						$("#tr_carrier_exapredict").html(exapredictresponse);
						$("#tr_carrier_exapredict").fadeIn('slow');
					}		
					
	$('#id_carrier' + {/literal}{$predict_carrier_id}{literal}).click(function(){
						document.getElementById('div_exapredict_block').style.display = "";
						document.forms['form'].action = '{/literal}{$urlExaPredict}{literal}';
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
	<i style="font-size:9px;">{l s='* Standard text messaging rates apply.' mod='exapaq'} {l s='Get more info in this video ' mod='exapaq'} <a class="more" target="_blank" href="https://www.youtube.com/watch?v=vLHThZDE8Ac"><img/></a></i>
</div>