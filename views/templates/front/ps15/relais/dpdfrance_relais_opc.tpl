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
{literal}
function dpdfrance_relais_redirect()
{
	checkedCarrier = $("input[name*='delivery_option[']:checked").val().substr(0,$("input[name*='delivery_option[']:checked").val().indexOf(','));
	if (checkedCarrier != dpdfranceRelaisCarrierId) {
		$("#form").attr("action", baseDir+'order.php');
		$("#tr_carrier_dpdfrance_relais").fadeOut('fast');
		if (document.getElementById("tr_carrier_dpdfrance_relais"))
			$("#tr_carrier_dpdfrance_relais").remove();
		$("#dpdfrance_relais_container").remove();
	} else {
		$("#form").attr("action", baseDir+'modules/dpdfrance/validation.php?dpdfrance_carrier=' + checkedCarrier);
		if (document.getElementById("dpdfrance_relais_point_table"))
			document.getElementById('dpdfrance_relais_point_table').style.display = "";
		$("#tr_carrier_dpdfrance_relais").html(dpdfrance_relais_response);
		$("#tr_carrier_dpdfrance_relais").fadeIn('fast');
	}
}

$(document).ready(function()
{
	carrier_block = $('input[class=delivery_option_radio]:checked').parents('div.delivery_option');
	$(carrier_block).append(
		'<div>'
			+'<table id="dpdfrance_relais_container" class="dpdfrance_relais_container" width="100%">'
				+'<tr>'
				+	'<td style="display:none;" id="id_carrier' + dpdfranceRelaisCarrierId + '" value="'+dpdfranceRelaisCarrierId+'" /></td>'
				+'</tr>'
			+'</table>'
		+'</div>');
	
	$('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).parent().parent().after("<tr><td colspan='4' style='padding:0; display:none;' id='tr_carrier_dpdfrance_relais'></td></tr>");

	dpdfrance_relais_response = $('#dpdfrance_relais_point_table');

	$("input[name*='delivery_option[']").change(function() {
		dpdfrance_relais_redirect();
	});
	dpdfrance_relais_redirect();
});

/* Hack de la librairie Uniform pour PS 1.6 : supprime les div qui entourent les boutons radio */
if (psVer >= 1.6)
{
	$(window).on('load', function(){
		$(".dpdfrance_radiopr").each(function() {
			radio = $(this).children('div').children('span').html();
			label = $(this).children('label').prop('outerHTML');
			$(this).html(radio).append(label);
		});
	});
}
{/literal}
</script>

<div id="dpdfrance_relais_filter" onclick="
var i = 1;
for (i=1; i<6; i++){
	document.getElementById('dpdfrance_relais_filter').style.display='none';
	document.getElementById('dpdfrance_relaydetail'+i).style.display='none';
}"></div>

<table align="center" id="dpdfrance_relais_point_table" class="dpdfrance_relaistable" style="display:none;">

{if isset($error)}
	<tr>
		<td colspan="5"><div class="dpdfrance_relais_error"> {$error|escape:'htmlall':'UTF-8'} </div></td>
	</tr>
{else}
	{if $dpdfrance_relais_status == 'error'}
		<tr>
			<td colspan="5" style="padding:0px;"><div class="dpdfrance_relais_error"><p>{l s='It seems that you haven\'t selected a DPD Pickup point, please pick one from this list' mod='dpdfrance'}</p></div></td>
		</tr>
	{/if}
	
	<tr>
		<td colspan="5" style="padding:0px;"><div id="dpdfrance_div_relais_header"><p>{l s='Please select your DPD Relais parcelshop among this list' mod='dpdfrance'}</p></div></td>
	</tr>

{foreach from=$dpdfrance_relais_points item=points name=dpdfranceRelaisLoop} 

<tr class="dpdfrance_lignepr" onclick="document.getElementById('{$points.relay_id|escape:'htmlall':'UTF-8'}').checked=true">
		<td align="left" class="dpdfrance_logorelais"></td>
		<td align="left" class="dpdfrance_adressepr"><b>{$points.shop_name|escape:'htmlall':'UTF-8'}</b><br/>{$points.address1|escape:'htmlall':'UTF-8'}<br/>{$points.postal_code|escape:'htmlall':'UTF-8'} {$points.city|escape:'htmlall':'UTF-8'}<br/></td>
		<td align="right" class="dpdfrance_distancepr">{$points.distance|escape:'htmlall':'UTF-8'} km</td>
		<td align="center" class="dpdfrance_popinpr">
			<span onMouseOver="javascript:this.style.cursor='pointer';" onMouseOut="javascript:this.style.cursor='auto';"
				onClick="openDpdfranceDialog('dpdfrance_relaydetail{$smarty.foreach.dpdfranceRelaisLoop.index+1|escape:'htmlall':'UTF-8'}','map_canvas{$smarty.foreach.dpdfranceRelaisLoop.index+1|escape:'htmlall':'UTF-8'}',{$points.coord_lat|escape:'htmlall':'UTF-8'},{$points.coord_long|escape:'htmlall':'UTF-8'},'{if $ssl}{$base_dir_ssl|escape:'htmlall':'UTF-8'}{else}{$base_dir|escape:'htmlall':'UTF-8'}{/if}')">
				<u>{l s='More details' mod='dpdfrance'}</u>
			</span>
		</td>
		<td align="center" class="dpdfrance_radiopr">
		<form method='post' action='{if $ssl}{$base_dir_ssl|escape:'htmlall':'UTF-8'}{else}{$base_dir|escape:'htmlall':'UTF-8'}{/if}modules/dpdfrance/validation.php?dpdfrance_carrier={$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}'>
		{if $dpdfrance_selectedrelay == $points.relay_id}
			<input type='submit' name="dpdfrance_relay_id_opc" id="{$points.relay_id|escape:'htmlall':'UTF-8'}" value="{$points.relay_id|escape:'htmlall':'UTF-8'}" class="dpdfrance_relais_buttonok" onMouseOver="javascript:this.style.cursor='pointer';" onMouseOut="javascript:this.style.cursor='auto';"></input>
		{else}
			<input type='submit' name="dpdfrance_relay_id_opc" id="{$points.relay_id|escape:'htmlall':'UTF-8'}" value="{$points.relay_id|escape:'htmlall':'UTF-8'}" class="dpdfrance_relais_buttonchoose" onMouseOver="javascript:this.style.cursor='pointer';" onMouseOut="javascript:this.style.cursor='auto';"></input>
		{/if}
		</form>
		</td>
</tr>

<div id="dpdfrance_relaydetail{$smarty.foreach.dpdfranceRelaisLoop.index+1|escape:'htmlall':'UTF-8'}" class="dpdfrance_relaisbox" style="display:none;">

	<div class="dpdfrance_relaisboxclose" onclick="
		document.getElementById('dpdfrance_relaydetail{$smarty.foreach.dpdfranceRelaisLoop.index+1|escape:'htmlall':'UTF-8'}').style.display='none';
		document.getElementById('dpdfrance_relais_filter').style.display='none'">
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
 
</table>
