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

<link rel="stylesheet" type="text/css" href="../modules/dpdfrance/views/css/admin/AdminDPDFrance.css"/>
<link rel="stylesheet" type="text/css" href="../modules/dpdfrance/views/js/admin/jquery/plugins/fancybox/jquery.fancybox.css" media="screen"/>
<script type="text/javascript" src="../modules/dpdfrance/views/js/admin/jquery/plugins/fancybox/jquery.fancybox.js"></script>
<script type="text/javascript" src="../modules/dpdfrance/views/js/admin/jquery/plugins/marquee/jquery.marquee.min.js"></script>

{literal}
<script type='text/javascript'>
	$(document).ready(function(){
		$('.marquee').marquee({
			duration: 20000,
			gap: 50,
			delayBeforeStart: 0,
			direction: 'left',
			duplicated: true,
			pauseOnHover: true
		});
	$('a.popup').fancybox({ 			
			'hideOnContentClick': true,
			'padding'			: 0,
			'overlayColor'		:'#D3D3D3',
			'overlayOpacity'	: 0.7,
			'width'				: 1024,
			'height'			: 640,
			'type'				:'iframe'
			});
		jQuery.expr[':'].contains = function(a, i, m) { 
			return jQuery(a).text().toUpperCase().indexOf(m[3].toUpperCase()) >= 0; 
		};
	$("#tableFilter").keyup(function () {
		//split the current value of tableFilter
		var data = this.value.split(";");
		//create a jquery object of the rows
		var jo = $("#fbody").find("tr");
		if (this.value == "") {
			jo.show();
			return;
		}
		//hide all the rows
		jo.hide();

		//Recusively filter the jquery object to get results.
		jo.filter(function (i, v) {
			var t = $(this);
			for (var d = 0; d < data.length; ++d) {
				if (t.is(":contains('" + data[d] + "')")) {
					return true;
				}
			}
			return false;
		})
		//show the rows that match.
		.show();
		}).focus(function () {
			this.value = "";
			$(this).css({
				"color": "black"
			});
			$(this).unbind('focus');
		}).css({
			"color": "#C0C0C0"
		});
	});
	 function checkallboxes(ele) {
		 var checkboxes = $("#fbody").find(".checkbox:visible");
		 if (ele.checked) {
			 for (var i = 0; i < checkboxes.length; i++) {
				 if (checkboxes[i].type == 'checkbox') {
					 checkboxes[i].checked = true;
				 }
			 }
		 } else {
			 for (var i = 0; i < checkboxes.length; i++) {
				 if (checkboxes[i].type == 'checkbox') {
					 checkboxes[i].checked = false;
				 }
			 }
		 }
	 }
</script>
{/literal}

{if $stream !== 'error'}
	<fieldset id="fieldset_rss"><legend><a href="javascript:void(0)" onclick="$(&quot;#zonemarquee&quot;).toggle(&quot;fast&quot;, function() {literal}{}{/literal});"><img src="../modules/dpdfrance/views/img/admin/rss_icon.png" />{l s='DPD News (show/hide)' mod='dpdfrance'}</a></legend>
	<div id="zonemarquee"><div id="marquee" class="marquee">
	{foreach from=$stream item=item key=key}
		<strong style="color:red;">{$item.category|escape:'htmlall':'UTF-8'} > {$item.title|escape:'htmlall':'UTF-8'} : </strong> {$item.description|escape:'htmlall':'UTF-8'} 
	{/foreach}
	</div></div></fieldset><br/>
{/if}

<fieldset id="fieldset_grid"><legend><img src="../modules/dpdfrance/views/img/admin/admin.png"/>{l s='DPD deliveries management' mod='dpdfrance'}</legend>

{if $order_info !== 'error'}
	<input id="tableFilter" value="{l s='Search something, separate values with ; ' mod='dpdfrance'}"/><img id="filtericon" src="../modules/dpdfrance/views/img/admin/search.png"/><br/><br/>
		<form id="exportform" action="index.php?tab=AdminDPDFrance&token={$token|escape:'htmlall':'UTF-8'}" method="POST" enctype="multipart/form-data">
		<body><table>
				<thead>
					<tr>
						<th class="hcheckexport"><input type="checkbox" onchange="checkallboxes(this)"/></th>
						<th class="hid">ID</th>
						<th class="href">{l s='Reference' mod='dpdfrance'}</th>
						<th class="hdate">{l s='Date of order' mod='dpdfrance'}</th>
						<th class="hnom">{l s='Recipient' mod='dpdfrance'}</th>
						<th class="htype">{l s='Service' mod='dpdfrance'}</th>
						<th class="hpr">{l s='Destination' mod='dpdfrance'}</th>
						<th class="hpoids">{l s='Weight' mod='dpdfrance'}</th>
						<th colspan="2" class="hprix" align="right">{l s='Amount' mod='dpdfrance'}<br/><span style="font-size:10px;">{l s='(tick to insure<br/>this parcel)' mod='dpdfrance'}</span></th>
						<th class="hstatutcommande" align="center">{l s='Order status' mod='dpdfrance'}</th>
						<th class="hstatutcolis" align="center">{l s='Parcel trace' mod='dpdfrance'}</th>
					</tr>
				</thead><tbody id="fbody">

		{foreach from=$order_info item=order}
			<tr>
				<td><input class="checkbox" type="checkbox" name="checkbox[]" {$order.checked|escape:'htmlall':'UTF-8'} value="{$order.id|escape:'htmlall':'UTF-8'}"></td><td class="id">{$order.id|escape:'htmlall':'UTF-8'}</td>
				<td class="ref">{$order.reference|escape:'htmlall':'UTF-8'}</td>
				<td class="date">{$order.date|escape:'htmlall':'UTF-8'}</td>
				<td class="nom">{$order.nom|escape:'htmlall':'UTF-8'}</td>
				<td class="type">{$order.type|escape:'quotes':'UTF-8'}</td>
				<td class="pr">{$order.address|escape:'quotes':'UTF-8'}</td>
				<td class="poids">{$order.poids|escape:'htmlall':'UTF-8'}</td>
				<td class="prix" align="right">{$order.prix|escape:'htmlall':'UTF-8'}</td>
				<td class="advalorem"><input class="advalorem" type="checkbox" name="advalorem[]" {$order.advalorem_checked|escape:'htmlall':'UTF-8'} value="{$order.id|escape:'htmlall':'UTF-8'}"></td>
				<td class="statutcommande" align="center">{$order.statut|escape:'quotes':'UTF-8'}</td>
				<td class="statutcolis" align="center"><a href="javascript:void(0)" onclick="window.open('http://www.dpd.fr/tracer_{$order.reference|escape:'htmlall':'UTF-8'}_{$order.depot_code|escape:'htmlall':'UTF-8'}{$order.shipper_code|escape:'htmlall':'UTF-8'}','','width=1024,height=768,top=30,left=20')">{$order.dernier_statut_colis|escape:'quotes':'UTF-8'}</a></td>
			</tr>
		{/foreach}
	</tbody></table>
	<p>
		<input type="submit" class="button" name="exportOrders" value="{l s='Export selected orders to DPD Station' mod='dpdfrance'}" />
		<input type="submit" class="button" name="updateShippedOrders" value="{l s='Update shipped orders' mod='dpdfrance'}" />
		<input type="submit" class="button" name="updateDeliveredOrders" value="{l s='Update delivered orders' mod='dpdfrance'}" />
	</p>
	</form></fieldset>
{else}
	<div class="alert warn">{l s='There are no orders' mod='dpdfrance'}</div>
{/if}