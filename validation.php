<?php
/**
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
 */

include('../../config/config.inc.php');
include('../../init.php');

/* Backward compatibility */
if (_PS_VERSION_ < '1.5')
	require_once('/backward_compatibility/backward.php');

$cart = (isset($cart) ? $cart : '');

if (version_compare(_PS_VERSION_, '1.5', '<'))
{
	if ((int)Configuration::get('PS_ORDER_PROCESS_TYPE') == 0)
		$delivery_option = Tools::getValue('id_carrier');
	else
		$delivery_option = $cart->id_carrier;
}
else
	$delivery_option = (Context::getContext()->cart->id_carrier == 0 ? Tools::getValue('id_carrier') : Context::getContext()->cart->id_carrier);

$cart->id_carrier = (int)$delivery_option;
$cart->gift = Tools::getValue('gift');
$cart->gift_message = Tools::getValue('gift_message');
$cart->update();

switch ((int)$delivery_option)
{
	case (int)Configuration::get('EXAPAQ_ICIRELAIS_CARRIER_ID'): /* If ICI relais carrier is selected */

	if ((int)Configuration::get('PS_ORDER_PROCESS_TYPE') == 0)
		$relay_id = Tools::getValue('relay_id');
	else
		$relay_id = Tools::getValue('relay_id_opc');

	if (!empty(Context::getContext()->cookie->exapaq_icirelais_cookie))
	{
		if (version_compare(_PS_VERSION_, '1.4.2.4', '>='))
			$cookiedata = Tools::jsonDecode(Context::getContext()->cookie->exapaq_icirelais_cookie, true); /* Retrieve details of chosen relaypoint in the cookie */
		else
			$cookiedata = json_decode(Context::getContext()->cookie->exapaq_icirelais_cookie, true);

		$detail_relais = $cookiedata[$relay_id];
		Db::getInstance()->delete(_DB_PREFIX_.'exapaq_france', 'id_cart = "'.$cart->id.'"'); /* Delete previous entry in database */

		$address1 = (isset($detail_relais['address1']))?$detail_relais['address1']:'';
		$address2 = (isset($detail_relais['address2']))?$detail_relais['address2']:'';
		$sql = 'INSERT IGNORE INTO '._DB_PREFIX_."exapaq_france 
				(id_customer, id_cart, id_carrier, service, relay_id, company, address1, address2, postcode, city, id_country, gsm_dest) 
				VALUES (
				'".(int)$cart->id_customer."',
				'".(int)$cart->id."',
				'".(int)$cart->id_carrier."',
				'REL',
				'$relay_id',
				'".$detail_relais['shop_name']."',
				'$address1',
				'$address2',
				'".$detail_relais['postal_code']."',
				'".$detail_relais['city']."',
				'".$detail_relais['id_country']."',
				''
				)";

		if (!Db::getInstance()->Execute($sql)) /* If error while writing in database : display an error message */
		{
			echo '<div class="alert error">Un problème est survenu lors de la sélection de votre point relais, merci de réessayer</div>';
			echo '<a href="javascript:history.back()">Retour</a>';
		}
		if (version_compare(_PS_VERSION_, '1.5', '<'))
			if ((int)Configuration::get('PS_ORDER_PROCESS_TYPE') == 0)
				Tools::redirect('order.php?step=3&cgv=1&icirelais=ok'); /* PS 1.4 STD */
			else
				Tools::redirect('order-opc.php?cgv=1&icirelais=ok#opc_delivery_methods'); /* PS 1.4 OPC */
		else
			if ((int)Configuration::get('PS_ORDER_PROCESS_TYPE') == 0)
				Tools::redirect('index.php?controller=order&step=3&cgv=1&icirelais=ok'); /* PS 1.5 STD */
			else
				Tools::redirect('index.php?controller=order-opc&isPaymentStep=true&cgv=1&icirelais=ok#carrier_area'); /* PS 1.5 OPC */
	}
	else
	{ /* While entering payment step, we check if relaypoint data is written. If it's OK then go to payment page. Else, redirect to carriers page */
		$sql = 'SELECT relay_id FROM '._DB_PREFIX_.'exapaq_france WHERE id_cart = '.$cart->id;
		$res = Db::getInstance()->ExecuteS($sql);
		foreach ($res as $relays) /* All right, go to payment page */
			Tools::redirect('index.php?controller=order&step=3&cgv=1&icirelais=ok');

		/* Else, set error parameter and redirect to carriers page */
		if (version_compare(_PS_VERSION_, '1.5', '<'))
			if ((int)Configuration::get('PS_ORDER_PROCESS_TYPE') == 0)
				Tools::redirect('order.php?step=2&cgv=1&icirelais=error'); /* PS 1.4 STD */
			else
				Tools::redirect('order-opc.php?cgv=1&icirelais=error#opc_delivery_methods'); /* PS 1.4 OPC */
		else
			if ((int)Configuration::get('PS_ORDER_PROCESS_TYPE') == 0)
				Tools::redirect('index.php?controller=order&step=2&cgv=1&icirelais=error'); /* PS 1.5 STD */
			else
				Tools::redirect('index.php?controller=order-opc&isPaymentStep=true&cgv=1&icirelais=error#carrier_area'); /* PS 1.5 OPC */
	}
	break;
	case (int)Configuration::get('EXAPAQ_PREDICT_CARRIER_ID') : /* If Predict carrier is selected */
		$exapredict_gsm_dest = Tools::getValue('exapredict_gsm_dest');
		$input_tel = Tools::getValue('exapredict_gsm_dest'); /* Get customer's mobile phone number entered */
		$elimine = array('00000000', '11111111', '22222222', '33333333', '44444444', '55555555', '66666666', '77777777', '88888888', '99999999', '123465789', '23456789', '98765432'); /* Patterns à éliminer */
		$gsm = str_replace(array(' ', '.', '-', ',', ';', '/', '\\', '(', ')'), '', $input_tel); /* Cleans the input - Result is 10 digits straight */
		$gsm = str_replace('+33', '0', $gsm); /* Prefix +33 is replaced by a 0 */

		if (!(bool)preg_match('#^0[6-7]([0-9]{8})$#', $gsm, $res) || (in_array($res[1], $elimine)))
		{ /* Check if prefix is 06 or 07, on 10 digits, and if the 8 following digits are not in the patterns to eliminate */
			/* Bad number : set error parameter and redirect to carriers page */
			if (version_compare(_PS_VERSION_, '1.5', '<'))
				if ((int)Configuration::get('PS_ORDER_PROCESS_TYPE') == 0)
					Tools::redirect('order.php?step=2&cgv=1&predict=error'); /* PS 1.4 STD */
				else
					Tools::redirect('order-opc.php?cgv=1&predict=error#opc_delivery_methods'); /* PS 1.4 OPC */
			else
				if ((int)Configuration::get('PS_ORDER_PROCESS_TYPE') == 0)
					Tools::redirect('index.php?controller=order&step=2&cgv=1&predict=error'); /* PS 1.5 STD */
				else
					Tools::redirect('index.php?controller=order-opc&isPaymentStep=true&cgv=1&predict=error#carrier_area'); /* PS 1.5 OPC */
		}
		else
		{ /* All right, delete previous entry of GSM for this cart and write the new one */
			Db::getInstance()->delete(_DB_PREFIX_.'exapaq_france', 'id_cart = "'.$cart->id.'"');
			$sql = 'INSERT IGNORE INTO '._DB_PREFIX_."exapaq_france 
						(id_customer, id_cart, id_carrier, service, relay_id, company, address1, address2, postcode, city, id_country, gsm_dest) 
						VALUES (
						'".(int)$cart->id_customer."',
						'".(int)$cart->id."',
						'".(int)$cart->id_carrier."',
						'PRE',
						'',
						'',
						'',
						'',
						'',
						'',
						'',
						'$gsm'
						)";

			if (!Db::getInstance()->Execute($sql)) /* If error while writing in database : display an error message */
			{
				echo '<div class="alert error">Un problème est survenu lors de l\'enregistrement de votre numéro de téléphone, merci de réessayer</div>';
				echo '<a href="javascript:history.back()">Retour</a>';
			}
			if (version_compare(_PS_VERSION_, '1.5', '<'))
				if ((int)Configuration::get('PS_ORDER_PROCESS_TYPE') == 0)
					Tools::redirect('order.php?step=3&cgv=1&predict=ok'); /* PS 1.4 STD */
				else
					Tools::redirect('order-opc.php?cgv=1&predict=ok#opc_delivery_methods'); /* PS 1.4 OPC */
			else
				if ((int)Configuration::get('PS_ORDER_PROCESS_TYPE') == 0)
					Tools::redirect('index.php?controller=order&step=3&cgv=1&predict=ok'); /* PS 1.5 STD */
				else
					Tools::redirect('index.php?controller=order-opc&isPaymentStep=true&cgv=1&predict=ok#carrier_area'); /* PS 1.5 OPC */
		}
		break;
	default :
	/* If the selected carrier is not one of ours : then go straight to payment page */
		if (version_compare(_PS_VERSION_, '1.5', '<'))
			if ((int)Configuration::get('PS_ORDER_PROCESS_TYPE') == 0)
				Tools::redirect('order.php?step=3&cgv=1&exapaq=bypass'); /* PS 1.4 STD */
			else
				Tools::redirect('order-opc.php?cgv=1&exapaq=bypass#opc_delivery_methods'); /* PS 1.4 OPC */
		else
			if ((int)Configuration::get('PS_ORDER_PROCESS_TYPE') == 0)
				Tools::redirect('index.php?controller=order&step=3&cgv=1&exapaq=bypass'); /* PS 1.5 STD */
			else
				Tools::redirect('index.php?controller=order-opc&isPaymentStep=true&cgv=1&exapaq=bypass#carrier_area'); /* PS 1.5 OPC */
		break;
}
exit;
?>