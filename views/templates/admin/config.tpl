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

<link rel="stylesheet" type="text/css" href="../modules/exapaq/views/css/admin/exapaq_config.css"/>
<link rel="stylesheet" type="text/css" href="../modules/exapaq/views/js/admin/jquery/plugins/fancybox/jquery.fancybox.css" media="screen"/>
<script type="text/javascript" src="../modules/exapaq/views/js/admin/jquery/plugins/fancybox/jquery.fancybox.js"></script>
<script type="text/javascript" src="../modules/exapaq/views/js/admin/jquery/plugins/validation/jquery.validate.min.js"></script>

{literal}
	<script type="text/javascript">
		$(document).ready(function() {
			exapaq_contact_form = $("#exapaq_contact_form").html();
		$('#open_pasclient').fancybox({
			autoDimensions: false, 
			minWidth: 640, 
			maxWidth: 960, 
			height: 700, 
			padding: 20, 
			modal: false,
			hideOnOverlayClick: true,
			beforeShow: function() {
				$("#contact_form").validate({
					rules: {
						raison_sociale: {
							required: true,
							minlength: 2
						},
						adresse: {
							required: true,
							minlength: 2
						},
						code_postal: {
							required: true,
							digits: true,
							minlength: 5
						},
						ville: {
							required: true,
							minlength: 2
						},
						telephone: {
							required: true,
							digits: true,
							minlength: 10
						},						
						message: {
							maxlength: 200,
						},
					},
					messages: {
						raison_sociale: " {/literal}{l s='Please enter your' mod='exapaq'} {l s='Company Name' mod='exapaq'}{literal}",
						adresse: " {/literal}{l s='Please enter your' mod='exapaq'} {l s='Address' mod='exapaq'}{literal}",
						code_postal: {
							required: " {/literal}{l s='Please enter your' mod='exapaq'} {l s='Postal code' mod='exapaq'}{literal}",
							minlength: " 5 {/literal}{l s='Minimum digits required' mod='exapaq'}{literal}",
							digits: " {/literal}{l s='Digits only' mod='exapaq'}{literal}",
						},
						ville: " {/literal}{l s='Please enter your' mod='exapaq'} {l s='City' mod='exapaq'}{literal}",
						telephone: {
							required: " {/literal}{l s='Please enter your' mod='exapaq'} {l s='Telephone' mod='exapaq'}{literal}",
							minlength: " 10 {/literal}{l s='Minimum digits required' mod='exapaq'}{literal}",
							digits: " {/literal}{l s='Digits only' mod='exapaq'}{literal}",
						},
						message: " {/literal}{l s='Your message can\'t exceed 200 characters' mod='exapaq'}{literal}",
					},
					submitHandler: function (form) {
						return true;
					}
				});
			}
		});
   });
</script>
{/literal}

 <div id="exapaq_contact_form" style="display: none;">
	<div style="text-align: left; margin:0; padding: 0">
		<img src="../modules/exapaq/logo.png" /> <h2 style="display: inline; vertical-align: middle; margin-left: 6px;">{l s='Get in touch with us!' mod='exapaq'}</h2>
	</div>

	<hr style="display: block; border-bottom: 1px solid #DDD;">

	<p style="margin-top: 20px; text-align: justify;">{l s='By choosing EXAPAQ, you will enjoy innovative delivery solutions: home appointment with our Predict service, to more than 5.000 relaypoints with ICI relais, on workplace with EXAPAQ Classic and worldwide with the DPD Classic Intercontinental services.' mod='exapaq'}</p>
	<p style="margin-top: 20px; text-align: justify;">{l s='Before starting our partnership, it is necessary to sign a contract with one of our sales representatives who will guide you and meet your expectations (parcel picking schedules, pricing conditions, number of shipments, labeling solution, packaging supplies...)' mod='exapaq'}</p>
	<p style="margin-top: 20px; text-align: justify;">{l s='Thank you in advance for completing this form so a sales representative can contact you as soon as possible.' mod='exapaq'}</p>

	<form id="contact_form" action="" method="post" style="margin-top: 20px; text-align: center">
		<dl style="text-align: left">
			<label for="raison_sociale" class="margin_contactform">{l s='Company Name' mod='exapaq'} : </label>
			<input type="text" value="" name="raison_sociale" id="raison_sociale" class="input_contactform"/><br/>			

			<label for="adresse" class="margin_contactform">{l s='Address' mod='exapaq'} : </label>
			<input type="text" value="" name="adresse" id="adresse" class="input_contactform"/> <br/>

			<label for="code_postal" class="margin_contactform">{l s='Postal code' mod='exapaq'} : </label>
			<input type="text" value="" name="code_postal" id="code_postal" class="input_contactform"/> <br/>

			<label for="ville" class="margin_contactform">{l s='City' mod='exapaq'} : </label>
			<input type="text" value="" name="ville" id="ville" class="input_contactform"/><br/>

			<label for="telephone" class="margin_contactform">{l s='Telephone' mod='exapaq'} : </label>
			<input type="text" value="" name="telephone" id="telephone" class="input_contactform"/><br/>

			<label for="volume_colis" class="margin_contactform">{l s='Mean number of parcels' mod='exapaq'} : </label>
				<select name="volume_colis" id="volume_colis" class="input_contactform">
					<option value="Je démarre mon activité">{l s='I\'m starting my business' mod='exapaq'}</option>
					<option value="< 100 colis / mois">{l s='< 100 parcels / month' mod='exapaq'}</option>
					<option value="100 à 500 colis / mois">{l s='100 to 500 parcels / month' mod='exapaq'}</option>
					<option value="> 500 colis / mois">{l s='> 500 parcels / month' mod='exapaq'}</option>
				</select>
			<br/>

			<label for="message" class="margin_contactform">{l s='Your message' mod='exapaq'} : </label>
			<textarea rows="5" value="" name="message" id="message" style="width: 200px; height: 150px;"></textarea><br/>
		</dl>

		<input type="submit" class="button" name="submitContactForm" value="{l s='Confirm' mod='exapaq'}" style="float: center; margin-top: 10px; padding: 10px 20px" />
	</form>
</div>

<form action="{$form_submit_url|escape:'htmlall':'UTF-8'}" method="post">
	<fieldset><legend><img src="../modules/exapaq/views/img/admin/admin.png" alt="" title="" />{l s='Settings' mod='exapaq'}</legend>
	
		<!-- Tabs header -->
		<div id="exapaq_menu">
			<ul id="onglets">
				<li><a id="onglet0" href="javascript:void(0)" onclick="$(&quot;#donnees_exp,#modes_transport,#options_supp,#gestion_exp,#recap&quot;).fadeOut(0, function() {literal}{{/literal}$(&quot;#accueil&quot;).fadeIn(&quot;slow&quot;){literal}}{/literal});"> {l s='Start' mod='exapaq'} </a></li>
				<li><a id="onglet1" href="javascript:void(0)" onclick="$(&quot;#accueil,#modes_transport,#options_supp,#gestion_exp,#recap&quot;).fadeOut(0, function() {literal}{{/literal}$(&quot;#donnees_exp&quot;).fadeIn(&quot;slow&quot;){literal}}{/literal});"> {l s='Your personal data' mod='exapaq'} </a></li>
				<li><a id="onglet2" href="javascript:void(0)" onclick="$(&quot;#accueil,#donnees_exp,#options_supp,#gestion_exp,#recap&quot;).fadeOut(0, function() {literal}{{/literal}$(&quot;#modes_transport&quot;).fadeIn(&quot;slow&quot;){literal}}{/literal});"> {l s='Delivery services' mod='exapaq'} </a></li>
				<li><a id="onglet3" href="javascript:void(0)" onclick="$(&quot;#accueil,#donnees_exp,#modes_transport,#gestion_exp,#recap&quot;).fadeOut(0, function() {literal}{{/literal}$(&quot;#options_supp&quot;).fadeIn(&quot;slow&quot;){literal}}{/literal});"> {l s='Advanced settings' mod='exapaq'} </a></li>
				<li><a id="onglet4" href="javascript:void(0)" onclick="$(&quot;#accueil,#donnees_exp,#modes_transport,#options_supp,#recap&quot;).fadeOut(0, function() {literal}{{/literal}$(&quot;#gestion_exp&quot;).fadeIn(&quot;slow&quot;){literal}}{/literal});"> {l s='Orders management' mod='exapaq'} </a></li>
				<li><a id="onglet5" href="javascript:void(0)" onclick="$(&quot;#accueil,#donnees_exp,#modes_transport,#options_supp,#gestion_exp&quot;).fadeOut(0, function() {literal}{{/literal}$(&quot;#recap&quot;).fadeIn(&quot;slow&quot;){literal}}{/literal});"> {l s='Summary' mod='exapaq'} </a></li>
			</ul>
		</div>

		<!-- Tab Accueil -->
		<div id="accueil" style="display:block;">
			<br/><span class="section_title">{l s='Welcome to EXAPAQ' mod='exapaq'}</span><br/>
			<div>{l s='Please configure the EXAPAQ module. Documentation is available here : ' mod='exapaq'}<a target="_blank" href="../modules/exapaq/docs/readme_exapaq_prestashop.pdf"><img src ="../modules/exapaq/views/img/admin/pdf.png" alt="PDF"/></a></div><br/>
			<div id="accueil_wrap">
				<div id="pasclient"><a id="open_pasclient" href="#exapaq_contact_form" style="text-decoration:none;"><span class="client_title">{l s='Not a customer yet?' mod='exapaq'}</span><div id="pasclient_img"></div><span class="client_subtitle">{l s='Click here to get in touch with our sales team' mod='exapaq'}</span></a></div>
				<div id="client" href="javascript:void(0)" onclick="$(&quot;#accueil,#modes_transport,#options_supp,#gestion_exp&quot;).fadeOut(0, function() {literal}{{/literal}$(&quot;#donnees_exp&quot;).fadeIn(&quot;slow&quot;){literal}}{/literal});"><span class="client_title">{l s='I\'m already a customer' mod='exapaq'}</span><div id="client_img"></div><span class="client_subtitle">{l s='Proceed to the plugin configuration' mod='exapaq'}</span></div>
				<br/>
			</div>
		</div>

		<!-- Tab Vos données expéditeur -->
		<div id="donnees_exp" style="display:none;">
			<br/><span class="section_title">{l s='Your personal data' mod='exapaq'}</span><br/><br/>

				<div id="donnees_exp_wrap">
				<label>{l s='Company Name' mod='exapaq'}</label><div class="margin-form"><input type="text" size="33" name="nom_exp" value="{$nom_exp|escape:'htmlall':'UTF-8'}" /></div>
				<label>{l s='Address 1' mod='exapaq'}</label><div class="margin-form"><input type="text" size="33" name="address_exp" value="{$address_exp|escape:'htmlall':'UTF-8'}" /></div>
				<label>{l s='Address 2' mod='exapaq'}</label><div class="margin-form"><input type="text" size="33" name="address2_exp" value="{$address2_exp|escape:'htmlall':'UTF-8'}" /></div>
				<label>{l s='Postal code' mod='exapaq'}</label><div class="margin-form"><input type="text" size="33" name="cp_exp" value="{$cp_exp|escape:'htmlall':'UTF-8'}" /></div>
				<label>{l s='City' mod='exapaq'}</label><div class="margin-form"><input type="text" size="33" name="ville_exp" value="{$ville_exp|escape:'htmlall':'UTF-8'}" /></div>
				<label>{l s='Telephone' mod='exapaq'}</label><div class="margin-form"><input type="text" size="33" name="tel_exp" value="{$tel_exp|escape:'htmlall':'UTF-8'}" /></div>
				<label>{l s='GSM' mod='exapaq'}</label><div class="margin-form"><input type="text" size="33" name="gsm_exp" value="{$gsm_exp|escape:'htmlall':'UTF-8'}" /></div>
				<label>{l s='E-mail' mod='exapaq'}</label><div class="margin-form"><input type="text" size="33" name="email_exp" value="{$email_exp|escape:'htmlall':'UTF-8'}" /></div>

				<center><a size="6" name="next" class="button" href="javascript:void(0)" onclick="$(&quot;#donnees_exp,#modes_transport,#options_supp,#gestion_exp,#recap&quot;).fadeOut(0, function() {literal}{{/literal}$(&quot;#accueil&quot;).fadeIn(&quot;slow&quot;){literal}}{/literal});">{l s='Previous' mod='exapaq'}</a> 
				<a size="6" name="next" class="button" href="javascript:void(0)" onclick="$(&quot;#donnees_exp,#options_supp,#gestion_exp&quot;).fadeOut(0, function() {literal}{{/literal}$(&quot;#modes_transport&quot;).fadeIn(&quot;slow&quot;){literal}}{/literal});">{l s='Next' mod='exapaq'}</a></center>
				<br/>
			</div>
		</div>

		<!-- Tab Services de transport -->
		<div id="modes_transport" style="display:none;">
			<br/><span class="section_title">{l s='Delivery services' mod='exapaq'}</span><br/><br/>
			<div id="modes_transport_wrap">

			<!-- ICI relais -->
			<div id="service_relais">
				<label>{l s='ICI relais by EXAPAQ' mod='exapaq'}</label>
				<div id="service_relais_img"></div>

				<span>{l s='Depot code - Contract number' mod='exapaq'}<br/>{l s='(i.e.: 013 - 12345)' mod='exapaq'}</span><br/><br/>
				<input type="text" size="3" name="icirelais_depot_code" class="icirelais_depot_code" value="{$icirelais_depot_code|escape:'htmlall':'UTF-8'}" /> - 
				<input type="text" size="5" name="icirelais_shipper_code" class="icirelais_shipper_code" value="{$icirelais_shipper_code|escape:'htmlall':'UTF-8'}" /><br/><br/>

				<span>{l s='Carrier assignation' mod='exapaq'}</span><br/><br/>
				<select name="icirelais_carrier_id"><option value="0">{l s='None - Disable this carrier' mod='exapaq'}</option>
				{foreach from=$carriers item=carrier} 
					{if $carrier.id_carrier == $icirelais_carrier_id}
						<option value="{$carrier.id_carrier|escape:'htmlall':'UTF-8'}" selected>{$carrier.id_carrier|escape:'htmlall':'UTF-8'} - {$carrier.name|escape:'htmlall':'UTF-8'}</option>
					{else}
						<option value="{$carrier.id_carrier|escape:'htmlall':'UTF-8'}">{$carrier.id_carrier|escape:'htmlall':'UTF-8'} - {$carrier.name|escape:'htmlall':'UTF-8'}</option>
					{/if}
				{/foreach}
				</select><br/><br/>

				<span>{l s='Carrier creation' mod='exapaq'}</span><br/><br/>
				<input type="submit" name="submitCreateCarrierIcirelais" value="{l s='Create ICI relais carrier' mod='exapaq'}" class="button"/> 
			</div>

			<!-- Predict -->
			<div id="service_predict">
				<label>{l s='Predict by EXAPAQ' mod='exapaq'}</label>
				<div id="service_predict_img"></div>

				<span>{l s='Depot code - Contract number' mod='exapaq'}<br/>{l s='(i.e.: 013 - 12345)' mod='exapaq'}</span><br/><br/>
				<input type="text" size="3" name="predict_depot_code" class="predict_depot_code" value="{$predict_depot_code|escape:'htmlall':'UTF-8'}" /> - 
				<input type="text" size="5" name="predict_shipper_code" class="predict_shipper_code" value="{$predict_shipper_code|escape:'htmlall':'UTF-8'}" /><br/><br/>

				<span>{l s='Carrier assignation' mod='exapaq'}</span><br/><br/>
				<select name="predict_carrier_id"><option value="0">{l s='None - Disable this carrier' mod='exapaq'}</option>
				{foreach from=$carriers item=carrier} 
					{if $carrier.id_carrier == $predict_carrier_id}
						<option value="{$carrier.id_carrier|escape:'htmlall':'UTF-8'}" selected>{$carrier.id_carrier|escape:'htmlall':'UTF-8'} - {$carrier.name|escape:'htmlall':'UTF-8'}</option>
					{else}
						<option value="{$carrier.id_carrier|escape:'htmlall':'UTF-8'}">{$carrier.id_carrier|escape:'htmlall':'UTF-8'} - {$carrier.name|escape:'htmlall':'UTF-8'}</option>
					{/if}
				{/foreach}
				</select><br/><br/>

				<span>{l s='Carrier creation' mod='exapaq'}</span><br/><br/>
				<input type="submit" name="submitCreateCarrierPredict" value="{l s='Create Predict carrier' mod='exapaq'}" class="button"/> 
			</div>

			<!-- Classic -->
			<div id="service_classic">
				<label>{l s='Classic by EXAPAQ' mod='exapaq'}</label>
				<label>{l s='DPD Intercontinental' mod='exapaq'}</label>
				<div id="service_classic_img"></div><div id="service_world_img"></div>

				<span>{l s='Depot code - Contract number' mod='exapaq'}<br/>{l s='(i.e.: 013 - 12345)' mod='exapaq'}</span><br/><br/>
				<input type="text" size="3" name="classic_depot_code" class="classic_depot_code" value="{$classic_depot_code|escape:'htmlall':'UTF-8'}" /> - 
				<input type="text" size="5" name="classic_shipper_code" class="classic_shipper_code" value="{$classic_shipper_code|escape:'htmlall':'UTF-8'}" /><br/><br/>

				<span>{l s='Carrier assignation' mod='exapaq'}</span><br/><br/>
				<select name="classic_carrier_id"><option value="0">{l s='None - Disable this carrier' mod='exapaq'}</option>
				{foreach from=$carriers item=carrier} 
					{if $carrier.id_carrier == $classic_carrier_id}
						<option value="{$carrier.id_carrier|escape:'htmlall':'UTF-8'}" selected>{$carrier.id_carrier|escape:'htmlall':'UTF-8'} - {$carrier.name|escape:'htmlall':'UTF-8'}</option>
					{else}
						<option value="{$carrier.id_carrier|escape:'htmlall':'UTF-8'}">{$carrier.id_carrier|escape:'htmlall':'UTF-8'} - {$carrier.name|escape:'htmlall':'UTF-8'}</option>
					{/if}
				{/foreach}
				</select><br/><br/>

				<span>{l s='Carrier creation' mod='exapaq'}</span><br/><br/>
				<input type="submit" name="submitCreateCarrierClassic" value="{l s='Create Classic carrier' mod='exapaq'}" class="button"/> 
				<input type="submit" name="submitCreateCarrierWorld" value="{l s='Create DPD World carrier' mod='exapaq'}" class="button"/><br/>
			</div>

			<div class="notabene">{l s='Please contact your EXAPAQ sales representative to get your contract numbers and depot code.' mod='exapaq'}</div><br/><br/>

			<center><a size="6" name="next" class="button" href="javascript:void(0)" onclick="$(&quot;#modes_transport,#options_supp,#gestion_exp&quot;).fadeOut(0, function() {literal}{{/literal}$(&quot;#donnees_exp&quot;).fadeIn(&quot;slow&quot;){literal}}{/literal});">{l s='Previous' mod='exapaq'}</a> 
			<a size="6" name="next" class="button" href="javascript:void(0)" onclick="$(&quot;#donnees_exp,#modes_transport,#gestion_exp&quot;).fadeOut(0, function() {literal}{{/literal}$(&quot;#options_supp&quot;).fadeIn(&quot;slow&quot;){literal}}{/literal});">{l s='Next' mod='exapaq'}</a></center>
			<br/>
			</div>
		</div>

		<!-- Tab Options supplémentaires -->
		<div id="options_supp" style="display:none;">
			<strong><br/>{l s='Advanced settings' mod='exapaq'}</strong><br/><br/>
			<label>{l s='ICI relais WebService URL' mod='exapaq'}</label><div class="margin-form"><input type="text" size="48" name="mypudo_url" value="{$mypudo_url|escape:'htmlall':'UTF-8'}" /> {l s='Caution! Critical setting' mod='exapaq'}</div>

			{if $ps_version >= '1.4'}
				<label>{l s='Coastal islands & Corsica overcost' mod='exapaq'}</label><div class="margin-form"><input type="text" size="3" name="supp_iles" value="{$supp_iles|escape:'htmlall':'UTF-8'}" />{l s=' € (-1 to disable delivery to these areas)' mod='exapaq'}</div>
				<label>{l s='Mountain areas overcost' mod='exapaq'}</label><div class="margin-form"><input type="text" size="3" name="supp_montagne" value="{$supp_montagne|escape:'htmlall':'UTF-8'}" />{l s=' € (-1 to disable delivery to these areas)' mod='exapaq'}</div>
			{/if}
			<center><a size="6" name="next" class="button" href="javascript:void(0)" onclick="$(&quot;#donnees_exp,#options_supp,#gestion_exp&quot;).fadeOut(0, function() {literal}{{/literal}$(&quot;#modes_transport&quot;).fadeIn(&quot;slow&quot;){literal}}{/literal});">{l s='Previous' mod='exapaq'}</a> 
			<a size="6" name="next" class="button" href="javascript:void(0)" onclick="$(&quot;#donnees_exp,#modes_transport,#options_supp&quot;).fadeOut(0, function() {literal}{{/literal}$(&quot;#gestion_exp&quot;).fadeIn(&quot;slow&quot;){literal}}{/literal});">{l s='Next' mod='exapaq'}</a></center>
			<br/>
		</div>

		<!-- Tab Gestion des expéditions -->
		<div id="gestion_exp" style="display:none;">
			<strong><br/><br/>{l s='Orders management' mod='exapaq'}</strong><br/><br/><br/>

			<label>{l s='Preparation in progress status' mod='exapaq'}<br/></label>
				<div class="margin-form">
				<select name="id_expedition">
				{foreach from=$etats_factures item=value} 
					{if $value.id_order_state == $exapaq_etape_expedition}
						<option value="{$value.id_order_state|escape:'htmlall':'UTF-8'}" selected>{$value.name|escape:'htmlall':'UTF-8'}</option>
					{else}
						<option value="{$value.id_order_state|escape:'htmlall':'UTF-8'}">{$value.name|escape:'htmlall':'UTF-8'}</option>
					{/if}
				{/foreach}
				</select><br/>{l s='Orders in this state will be selected by default for exporting.' mod='exapaq'}<br/>
			</div>
			
			<label>{l s='Shipped status' mod='exapaq'}<br/></label>
			<div class="margin-form">
				<select name="id_expedie">
				{foreach from=$etats_factures item=value} 
					{if $value.id_order_state == $exapaq_etape_expediee}
						<option value="{$value.id_order_state|escape:'htmlall':'UTF-8'}" selected>{$value.name|escape:'htmlall':'UTF-8'}</option>
					{else}
						<option value="{$value.id_order_state|escape:'htmlall':'UTF-8'}">{$value.name|escape:'htmlall':'UTF-8'}</option>
					{/if}
				{/foreach}
				</select><br/>{l s='Once parcel trackings are generated, orders will be updated to this state.' mod='exapaq'}<br/>
			</div>

			<label>{l s='Delivered status' mod='exapaq'}<br/></label>
			<div class="margin-form">
				<select name="id_livre">
				{foreach from=$etats_factures item=value} 
					{if $value.id_order_state == $exapaq_etape_livre}
						<option value="{$value.id_order_state|escape:'htmlall':'UTF-8'}" selected>{$value.name|escape:'htmlall':'UTF-8'}</option>
					{else}
						<option value="{$value.id_order_state|escape:'htmlall':'UTF-8'}">{$value.name|escape:'htmlall':'UTF-8'}</option>
					{/if}
				{/foreach}
				</select><br/>{l s='Once parcels are delivered, orders will be updated to this state.' mod='exapaq'}<br/>
			</div>

			<label>{l s='Parcel insurance service' mod='exapaq'}<br/></label>
			<div class="margin-form">
				<select name="ad_valorem">
				{foreach from=$optvd item=option key=key} 
					{if $key == $exapaq_ad_valorem}
						<option value="{$key|escape:'htmlall':'UTF-8'}" selected>{$option|escape:'htmlall':'UTF-8'}</option>
					{else}
						<option value="{$key|escape:'htmlall':'UTF-8'}">{$option|escape:'htmlall':'UTF-8'}</option>
					{/if}
				{/foreach}
				</select><br/>{l s='Ad Valorem : Please refer to your pricing conditions.' mod='exapaq'}<br/>
			</div>
			
			<center><a size="6" name="next" class="button" href="javascript:void(0)" onclick="$(&quot;#donnees_exp,#modes_transport,#gestion_exp&quot;).fadeOut(0, function() {literal}{{/literal}$(&quot;#options_supp&quot;).fadeIn(&quot;slow&quot;){literal}}{/literal});">{l s='Previous' mod='exapaq'}</a> 
			<a size="6" name="next" class="button" href="javascript:void(0)" onclick="$(&quot;#accueil,#donnees_exp,#modes_transport,#options_supp,#gestion_exp&quot;).fadeOut(0, function() {literal}{{/literal}$(&quot;#recap&quot;).fadeIn(&quot;slow&quot;){literal}}{/literal});">{l s='Next' mod='exapaq'}</a></center>
			<br/>
		</div>

		<!-- Tab Recapitulatif -->
		<div id="recap" style="display:none;">
			<strong><center><br/><br/>{l s='You\'re all set!' mod='exapaq'}</center></strong><br/><br/>
			<center><input id="save_settings_button" type="submit" name="submitRcReferer" value="{l s='Save settings' mod='exapaq'}" class="button" /></center></br>
			<center><a size="6" name="next" class="button" href="javascript:void(0)" onclick="$(&quot;#donnees_exp,#modes_transport,#options_supp,#recap&quot;).fadeOut(0, function() {literal}{{/literal}$(&quot;#gestion_exp&quot;).fadeIn(&quot;slow&quot;){literal}}{/literal});">{l s='Return to configuration' mod='exapaq'}</a></center><br/>
			<br/>
		</div>
	</fieldset>
</form>