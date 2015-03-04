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
var iciCarrierId = "{$icirelais_carrier_id|escape:'htmlall':'UTF-8'}";
var psVer = "{$ps_version|escape:'htmlall':'UTF-8'}";
{literal}

function icirelais_redirect() {
	checkedCarrier = $("input[name*='delivery_option[']:checked").val().substr(0,$("input[name*='delivery_option[']:checked").val().indexOf(','));
	if (checkedCarrier != iciCarrierId) {
		$("#form").attr("action", baseDir+'index.php?controller=order');
		$("#tr_carrier_icirelais").fadeOut('fast');
		if (document.getElementById("tr_carrier_icirelais"))
			$("#tr_carrier_icirelais").remove();
		$("#icirelais_container").remove();
	} else {
		$("#form").attr("action", baseDir+'modules/exapaq/validation.php?exa_carrier=' + checkedCarrier);
		if (document.getElementById("icirelais_point_table"))
			document.getElementById('icirelais_point_table').style.display = "";
		$("#tr_carrier_icirelais").html(iciresponse);
		$("#tr_carrier_icirelais").fadeIn('fast');
	}
}

$(document).ready(function() {
	carrier_block = $('input[class=delivery_option_radio]:checked').parents('div.delivery_option');
	$(carrier_block).append(
		'<div>'
			+'<table id="icirelais_container" class="icirelais_container" width="100%">'
				+'<tr>'
				+	'<td style="display:none;" id="id_carrier' + iciCarrierId + '" value="'+iciCarrierId+'" /></td>'
				+'</tr>'
			+'</table>'
		+'</div>');
	
	$('#id_carrier' + {/literal}{$icirelais_carrier_id|escape:'htmlall':'UTF-8'}{literal}).parent().parent().after("<tr><td colspan='4' style='padding:0; display:none;' id='tr_carrier_icirelais'></td></tr>");

	iciresponse = $('#icirelais_point_table');

	$("input[name*='delivery_option[']").change(function() {
		icirelais_redirect();
	});
	icirelais_redirect();
});

/* Hack de la librairie Uniform pour PS 1.6 : supprime les div qui entourent les boutons radio */
if (psVer >= 1.6)
{
	$(window).load(function(){
		$(".radiopr").each(function() {
			radio = $(this).children('div').children('span').html();
			label = $(this).children('label').prop('outerHTML');
			$(this).html(radio).append(label);
		});
	});
}
{/literal}
</script>
<div id="filter" onclick="
var i = 1;
for (i=1; i<6; i++){
    document.getElementById('filter').style.display='none';
    document.getElementById('relaydetail'+i).style.display='none';
}"></div>

<table align="center" id="icirelais_point_table" class="icitable" style="display:none;">
{if isset($error)}
	<tr>
		<td colspan="5"><div class="icirelais_error"> {$error|escape:'htmlall':'UTF-8'} </div></td>
	</tr>
{else}
	{if $icirelais_status == 'error'}
		<tr>
			<td colspan="5" style="padding:0px;"><div class="icirelais_error"><p>{l s='It seems that you haven\'t selected an ICI relais point, please pick one from this list' mod='exapaq'}</p></div></td>
		</tr>
	{/if}

	<tr>
		<td colspan="5" style="padding:0px;"><div id="div_icirelais_header"><p>{l s='Please select your ICI relais parcelshop among this list' mod='exapaq'}</p></div></td>
	</tr>

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
		{if $selectedrelay == $points.relay_id}
			<input type="radio" name="relay_id" id="{$points.relay_id|escape:'htmlall':'UTF-8'}" value="{$points.relay_id|escape:'htmlall':'UTF-8'}" checked="checked">
		{else}
			<input type="radio" name="relay_id" id="{$points.relay_id|escape:'htmlall':'UTF-8'}" value="{$points.relay_id|escape:'htmlall':'UTF-8'}" {if $smarty.foreach.iciLoop.first} checked="checked" {/if}>
		{/if}
			<label for="{$points.relay_id|escape:'htmlall':'UTF-8'}"><span><span></span></span><b>ICI</b></label>
		</td>
</tr>

<div id="relaydetail{$smarty.foreach.iciLoop.index+1|escape:'htmlall':'UTF-8'}" class="icirelaisbox" style="display:none;">

	<div class="icirelaisboxclose" onclick="
		document.getElementById('relaydetail{$smarty.foreach.iciLoop.index+1|escape:'htmlall':'UTF-8'}').style.display='none';
		document.getElementById('filter').style.display='none'">
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
 
</table>