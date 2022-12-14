package com.swan.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.swan.model.MemberVO;
import com.swan.model.OrderDTO;
import com.swan.model.OrderListVO;
import com.swan.model.OrderPageDTO;
import com.swan.service.MemberService;
import com.swan.service.OrderService;

@Controller
public class OrderController {

	public static final String IMPORT_TOKEN_URL = "https://api.iamport.kr/users/getToken";
	public static final String IMPORT_PAYMENTINFO_URL = "https://api.iamport.kr/payments/find/";
	public static final String IMPORT_CANCEL_URL = "https://api.iamport.kr/payments/cancel";
	public static final String IMPORT_PREPARE_URL = "https://api.iamport.kr/payments/prepare";

	public static final String KEY = "";
	public static final String SECRET = "";

	@Autowired
	private OrderService orderService;

	@Autowired
	private MemberService memberService;

	// ???????????? ??????(??????)??? ???????????? ??????
	public String getImportToken() {
		String result = "";
		
		HttpClient client = HttpClientBuilder.create().build();
		
		HttpPost post = new HttpPost(IMPORT_TOKEN_URL);
		
		Map<String, String> m = new HashMap<String, String>();
		
		m.put("imp_key", KEY);
		
		m.put("imp_secret", SECRET);
		try {
			post.setEntity(new UrlEncodedFormEntity(convertParameter(m)));
			HttpResponse res = client.execute(post);
			ObjectMapper mapper = new ObjectMapper();
			String body = EntityUtils.toString(res.getEntity());
			JsonNode rootNode = mapper.readTree(body);
			JsonNode resNode = rootNode.get("response");
			result = resNode.get("access_token").asText();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// Map??? ???????????? Http?????? ??????????????? ????????? ?????? ??????
	private List<NameValuePair> convertParameter(Map<String, String> paramMap) {
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();

		Set<Entry<String, String>> entries = paramMap.entrySet();

		for (Entry<String, String> entry : entries) {
			paramList.add(new BasicNameValuePair(entry.getKey(), entry.getValue()));
		}
		return paramList;
	}

	// '?????? ?????????' ????????? ???????????? URL ?????? ???????????? ??????
	@RequestMapping(value = "/orders/{member_id}", method = { RequestMethod.GET, RequestMethod.POST })
	// URL??? ?????? ???????????? member_id??? ???????????? ????????? ???????????????, ?????? ????????? ???????????? ??? ????????? OrderPageDTO ?????????
	// ????????? ??????. ????????? ??? ??????????????? ???????????? ????????? ?????? ???????????? ????????? Mdoel ????????? ???????????? ????????? ??????
	public String orderPageGet(@PathVariable("member_id") String member_id, OrderPageDTO opd, Model model) {

		// ?????? ?????? ????????? ?????? Service
		model.addAttribute("orderList", orderService.getProductsInfo(opd.getOrders()));

		// ?????? ?????? ??????????????? Service
		model.addAttribute("memberInfo", memberService.getMemberInfo(member_id));

		return "/orders";

	}

	// ????????? ???????????? '??????'??? ???????????? URL ?????? ?????????
	@GetMapping(value = "/orders")
	public String orderPagePost(OrderDTO od, HttpServletRequest request) {

		System.out.println(od);

		orderService.order(od);

		// ?????? ?????? session??? "member"??? ?????? ?????? ????????? MemberVO ????????? ?????????
		MemberVO member = new MemberVO();
		member.setId(od.getMember_id());

		HttpSession session = request.getSession();

		try {
			MemberVO memberLogin = memberService.login(member);
			session.setAttribute("member", memberLogin);

		} catch (Exception e) {

			e.printStackTrace();
		}

		return "redirect:/swan";
	}

	/* ?????? */
	@RequestMapping(value = "/cancel")
	@ResponseBody
	public int cancelPayment(String token, String merchant_uid) {
		HttpClient client = HttpClientBuilder.create().build();
		HttpPost post = new HttpPost(IMPORT_CANCEL_URL);
		Map<String, String> map = new HashMap<String, String>();
		post.setHeader("Authorization", token);
		map.put("merchant_uid", merchant_uid);
		String asd = "";
		
		try {
			post.setEntity(new UrlEncodedFormEntity(convertParameter(map)));
			HttpResponse res = client.execute(post);
			ObjectMapper mapper = new ObjectMapper();
			String enty = EntityUtils.toString(res.getEntity());
			JsonNode rootNode = mapper.readTree(enty);
			asd = rootNode.get("response").asText();
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (asd.equals("null")) {
			System.err.println("?????? ??????");
			return -1;
		} else {
			System.err.println("?????? ??????");
			return 1;
		}
	}
	
	// ???????????? ??????????????? ???????????? ??????????????? ???????????? ??????
		public String getAmount(String token, String mId) {
			String amount = "";
			HttpClient client = HttpClientBuilder.create().build();
			HttpGet get = new HttpGet(IMPORT_PAYMENTINFO_URL + mId + "/paid");
			get.setHeader("Authorization", token);

			try {
				HttpResponse res = client.execute(get);
				ObjectMapper mapper = new ObjectMapper();
				String body = EntityUtils.toString(res.getEntity());
				JsonNode rootNode = mapper.readTree(body);
				JsonNode resNode = rootNode.get("response");
				amount = resNode.get("amount").asText();
			} catch (Exception e) {
				e.printStackTrace();
			}

			return amount;
		}
		
	    // ???????????? ???????????? ????????? ???????????? ??????
		public void setHackCheck(String amount,String mId,String token) {
			HttpClient client = HttpClientBuilder.create().build();
			HttpPost post = new HttpPost(IMPORT_PREPARE_URL);
			Map<String,String> m  =new HashMap<String,String>();
			post.setHeader("Authorization", token);
			m.put("amount", amount);
			m.put("merchant_uid", mId);
			try {
				post.setEntity(new UrlEncodedFormEntity(convertParameter(m)));
				HttpResponse res = client.execute(post);
				ObjectMapper mapper = new ObjectMapper();
				String body = EntityUtils.toString(res.getEntity());
				JsonNode rootNode = mapper.readTree(body);
				System.out.println(rootNode);
			} catch (Exception e) {
				e.printStackTrace();
			}	
		}

	/* ?????? ???????????? ?????? ???????????? */
	@GetMapping("/orderList/{member_id}")
	public String orderList(OrderDTO order, Model model, HttpSession session) throws Exception {
		MemberVO member = (MemberVO) session.getAttribute("member");
		String userId = member.getId();
		order.setMember_id(userId);
		List<OrderDTO> orderList = orderService.orderList(order);

		model.addAttribute("orderList", orderList);

		return "/orderList";

	}

	/* ?????? ?????? */
	@RequestMapping(value = "/orderList", method = RequestMethod.GET)
	public void getOrderList(HttpSession session, OrderDTO order, Model model) throws Exception {

		MemberVO member = (MemberVO) session.getAttribute("member");
		String userId = member.getId();

		order.setMember_id(userId);

		List<OrderDTO> orderList = orderService.orderList(order);

		model.addAttribute("orderList", orderList);
	}

	/* ?????? ?????? ?????? */
	@RequestMapping(value = "/orderView", method = RequestMethod.GET)
	public void getOrderList(HttpSession session, @RequestParam("n") String order_id, OrderDTO order, Model model)
			throws Exception {

		MemberVO member = (MemberVO) session.getAttribute("member");
		String userId = member.getId();

		order.setMember_id(userId);
		order.setOrder_id(order_id);

		List<OrderListVO> orderView = orderService.orderView(order);

		model.addAttribute("orderView", orderView);
	}

}
