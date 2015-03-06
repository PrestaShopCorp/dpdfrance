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

<link href='http://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css'>
<script type="text/javascript">
    var badIE = false;
</script>

<!--[if lt IE 8]>
	<script type="text/javascript">badIE = true;</script>
<![endif]-->
<script type="text/javascript">
if (badIE == false){
	{literal}
	
	$(document).ready(function(){
		checkedCarrier = $("input[name*='id_carrier']:checked").val();
		if ($("#div_icirelais_error").length==0){
			var i;
			var tabInput = document.getElementsByName("ligneici");
			var n = 5;
			
			for (i=0; i<n; i++){
				document.getElementById("ligneici").id = 'ligneici'+i;
			}
			
			$('#id_carrier' + {/literal}{$icirelais_carrier_id|escape:'javascript':'UTF-8'}{literal}).parent().parent().after("<tr><td colspan='4' style='padding:0; display:none' id='tr_carrier_icirelais'></td></tr>");

			iciresponse = [div_icirelais_header,ligneici0,ligneici1,ligneici2,ligneici3,ligneici4]
		   
			if ($('#id_carrier' + {/literal}{$icirelais_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked')){
				$.when($('#div_icirelais_header,#ligneici0,#ligneici1,#ligneici2,#ligneici3,#ligneici4').show('fast')).done(function() {
					$("#tr_carrier_icirelais").html(iciresponse);
					$("#tr_carrier_icirelais").fadeIn('slow');
					$("#submit_relais_opc").attr("action", baseDir+'modules/exapaq/validation.php?exa_carrier=' + checkedCarrier);
				});
			}
			
			$('#id_carrier' + {/literal}{$icirelais_carrier_id|escape:'javascript':'UTF-8'}{literal}).click(function(){
				$.when($('#div_icirelais_header,#ligneici0,#ligneici1,#ligneici2,#ligneici3,#ligneici4').show('fast')).done(function() {
					$("#tr_carrier_icirelais").html(iciresponse);
					$("#tr_carrier_icirelais").fadeIn('slow');
					$("#submit_relais_opc").attr("action", baseDir+'modules/exapaq/validation.php?exa_carrier=' + checkedCarrier);
				});
			});
							
			$("input[name='id_carrier']").change(function(){
				if (!$('#id_carrier' + {/literal}{$icirelais_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked')){
					$("#tr_carrier_icirelais").fadeOut('fast');
				}
			});
		}
		else
		{
			if ($('#id_carrier' + {/literal}{$icirelais_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked'))
				$("#div_icirelais_header").fadeIn('slow');
			
			$('#id_carrier' + {/literal}{$icirelais_carrier_id|escape:'javascript':'UTF-8'}{literal}).click(function(){
				$("#div_icirelais_header").fadeIn('slow');
			});
							
			$("input[name='id_carrier']").change(function(){
				if (!$('#id_carrier' + {/literal}{$icirelais_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked'))
					$("#div_icirelais_header").fadeOut('fast');
			});
		}
	});
	{/literal}
	
}else{

	{literal}
	$(document).ready(function(){
		checkedCarrier = $("input[name*='id_carrier']:checked").val();
		if ($("#div_icirelais_error").length==0){
			var i;
			var tabInput = document.getElementsByName("ligneici");
			var n = 5;
			
			for (i=0; i<n; i++){
				document.getElementById("ligneici").id = 'ligneici'+i;
			}
			
			if ($('#id_carrier' + {/literal}{$icirelais_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked')){
				document.getElementById('ligneici0').style.display = "";
				document.getElementById('ligneici1').style.display = "";
				document.getElementById('ligneici2').style.display = "";
				document.getElementById('ligneici3').style.display = "";
				document.getElementById('ligneici4').style.display = "";
				$('#div_icirelais_header').fadeIn('fast', function() {});
				$("#submit_relais_opc").attr("action", baseDir+'modules/exapaq/validation.php?exa_carrier=' + checkedCarrier);
			}else{
				document.getElementById('ligneici0').style.display = "none";
				document.getElementById('ligneici1').style.display = "none";
				document.getElementById('ligneici2').style.display = "none";
				document.getElementById('ligneici3').style.display = "none";
				document.getElementById('ligneici4').style.display = "none";
				$('#div_icirelais_header').fadeOut('fast', function() {});
			}
			
			$('#id_carrier' + {/literal}{$icirelais_carrier_id|escape:'javascript':'UTF-8'}{literal}).click(function(){
				document.getElementById('ligneici0').style.display = "";
				document.getElementById('ligneici1').style.display = "";
				document.getElementById('ligneici2').style.display = "";
				document.getElementById('ligneici3').style.display = "";
				document.getElementById('ligneici4').style.display = "";
				$('#div_icirelais_header').fadeIn('fast', function() {});
				$("#submit_relais_opc").attr("action", baseDir+'modules/exapaq/validation.php?exa_carrier=' + checkedCarrier);
			});
							
			$("input[name='id_carrier']").change(function(){
				if (!$('#id_carrier' + {/literal}{$icirelais_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked')){
					document.getElementById('ligneici0').style.display = "none";
					document.getElementById('ligneici1').style.display = "none";
					document.getElementById('ligneici2').style.display = "none";
					document.getElementById('ligneici3').style.display = "none";
					document.getElementById('ligneici4').style.display = "none";
					$('#div_icirelais_header').fadeOut('fast', function() {});
				}
			});
		}
		else
		{
			if ($('#id_carrier' + {/literal}{$icirelais_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked'))
				$("#div_icirelais_header").fadeIn('slow');
			
			$('#id_carrier' + {/literal}{$icirelais_carrier_id|escape:'javascript':'UTF-8'}{literal}).click(function(){
				$("#div_icirelais_header").fadeIn('slow');
			});
							
			$("input[name='id_carrier']").change(function(){
				if (!$('#id_carrier' + {/literal}{$icirelais_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked'))
					$("#div_icirelais_header").fadeOut('fast');
			});
		}
	});
{/literal}
}
</script>

<tr id="div_icirelais_header" style="display:none;">
	{if isset($error)}
		<td colspan="4" id="div_icirelais_error" class="alert warning"> {$error|escape:'htmlall':'UTF-8'}</td>
			<tr>
				<td colspan="4" style="display:none;">&nbsp;</td>
			</tr>
	{else}
		<td colspan="4">
				<p>
				{l s='Please select your ICI relais parcelshop among this list' mod='exapaq'}
				</p>
		</td>

	{if $icirelais_status == 'error'}
		<tr>
			<td colspan="5" style="padding:0px;"><div class="icirelais_error"><p>{l s='It seems that you haven\'t selected an ICI relais point, please pick one from this list' mod='exapaq'}</p></div></td>
		</tr>
	{/if}
</tr>

{foreach from=$ici_relais_points item=points name=iciLoop} 
<tr id="ligneici" style="display:none;width:100%;font-family: 'Open Sans', sans-serif;">
	<td align="left" class="logoicirelais" id="logoicirelais">
	</td>
	
	<td align="left" class="adressepr"><b>{$points.shop_name|escape:'htmlall':'UTF-8'}</b><br>{$points.address1|escape:'htmlall':'UTF-8'}<br>{$points.postal_code|escape:'htmlall':'UTF-8'} {$points.city|escape:'htmlall':'UTF-8'}
	</td>
		
	<td align="right" class="popinpr">
		
		<form method='post' target="_blank" action='http://www.icirelais.com/point-relais' style="width:90px;">
			<input id="code" type="hidden" name="code" type="submit" value='{$points.relay_id|escape:'htmlall':'UTF-8'}'.'&button=Rechercher'>
			<a class="notfancy" onclick="$(this).closest('form').submit();">
				<span onMouseOver="javascript:this.style.cursor='pointer';" onMouseOut="javascript:this.style.cursor='auto';">
					</u>{$points.distance|escape:'htmlall':'UTF-8'} km<br/>{l s='More details' mod='exapaq'}</u>
				</span>
			</a>
		</form>
	</td>
	
	<td align="right" class="icirelais_radio radio">
			
		<form method='post' action='{if $ssl}{$base_dir_ssl|escape:'htmlall':'UTF-8'}{else}{$base_dir|escape:'htmlall':'UTF-8'}{/if}modules/exapaq/validation.php' style="width:15%;">
		{if $selectedrelay == $points.relay_id}
			<input type='submit' name="relay_id_opc" id="{$points.relay_id|escape:'htmlall':'UTF-8'}" value="{$points.relay_id|escape:'htmlall':'UTF-8'}" class="icibuttonok" onMouseOver="javascript:this.style.cursor='pointer';" onMouseOut="javascript:this.style.cursor='auto';"></input>
		{else}
			<input type='submit' name="relay_id_opc" id="{$points.relay_id|escape:'htmlall':'UTF-8'}" value="{$points.relay_id|escape:'htmlall':'UTF-8'}" class="icibuttonchoose" onMouseOver="javascript:this.style.cursor='pointer';" onMouseOut="javascript:this.style.cursor='auto';"></input>
		{/if}
		</form>	
	</td>
</tr>

</td>

{/foreach}

{/if}
</div>
</td>