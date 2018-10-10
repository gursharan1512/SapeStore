package com.sapestore.controller;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.Key;
import java.security.KeyStore;
import java.security.KeyStore.LoadStoreParameter;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.List;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.X509TrustManager;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.sapestore.common.ApplicationConstants;
import com.sapestore.common.SapeStoreLogger;
import com.sapestore.exception.SapeStoreException;
import com.sapestore.exception.SapeStoreSystemException;
import com.sapestore.hibernate.entity.Book;
import com.sapestore.service.BookService;
import com.sapestore.service.ShoppingCartService;
import com.sapestore.vo.BookVO;
import com.sapestore.vo.ShoppingCartVO;
import com.sapestore.vo.UserVO;

@Controller
@SessionAttributes("RecommendList")
public class RecommendController {

	/** The recommend list. */
	private List<Book> recommendList;

	public List<Book> getRecommendList() {
		return recommendList;
	}

	public void setRecommendList(List<Book> recommendList) {
		this.recommendList = recommendList;
	}

	/** The book service. */
	@Autowired
	private BookService bookService;

	/**
	 * Gets the book service.
	 *
	 * @return the book service
	 */
	public BookService getBookService() {
		return bookService;
	}

	/**
	 * Sets the book service.
	 *
	 * @param bookService
	 *            the new book service
	 */
	public void setBookService(BookService bookService) {
		this.bookService = bookService;
	}

	/** The Constant LOGGER. */
	private static final SapeStoreLogger LOGGER = SapeStoreLogger
			.getLogger(HomePageController.class.getName());

	/*
	 * @RequestMapping(value = "/getRecommendBooks", method = RequestMethod.GET)
	 * public ModelAndView getRecommendBooks(@RequestParam("dsessionId") String
	 * dsessionId, ModelMap modelMap, HttpSession httpSession) throws Exception
	 * {
	 * 
	 * // populate recommendList recommendList = getRecommendsList(0, false, 0);
	 * this.setRecommendList(recommendList);
	 * 
	 * System.out.println(dsessionId);
	 * System.out.println("inside recommendBooks method");
	 * 
	 * // set recommendList in jsp modelMap.addAttribute("RecommendList",
	 * this.getRecommendList());
	 * 
	 * return new ModelAndView("newRecommBook");
	 * 
	 * }
	 */

	@RequestMapping(value = "/getRecommendBooksDetail", method = RequestMethod.GET)
	public ModelAndView getRecommendBooksDetail(
			@RequestParam("dsessionId") String dsessionId, @RequestParam("isbnfrom") String isbnfrom, ModelMap modelMap,
			HttpSession httpSession,HttpServletResponse httpServletResponse, 
			HttpServletRequest httpServletRequest) throws Exception {

		System.out
				.println("-------------------------inside recomm new-------------------------");
		// RestTemplate template = new RestTemplate();
		String requestUrl = "https://52.39.59.106:8000/queries.json";
		// URL url = new URL(requestUrl);
		String payload = "{ \"items\": [\""+isbnfrom+"\"], \"num\": 3 }";

		String response = sendPostRequest(requestUrl, payload);
		System.out.println(response);
		
		List<Book> recommendListlocal=new ArrayList<Book>();
		
		JSONObject jsonObj = new JSONObject(response);
		
		JSONArray jsonarr = jsonObj.getJSONArray("itemScores");
		for (int i = 0; i < jsonarr.length(); i++)
		{
		    String item = jsonarr.getJSONObject(i).getString("item");
		    System.out.println(item);
		    Book book=bookfromisbn(item);
		    recommendListlocal.add(book);
		}
		
		this.setRecommendList(recommendListlocal); // set recommendList in jsp
		modelMap.addAttribute("RecommendList", this.getRecommendList());
		//setting SESSID in cookie
		String sessId = httpServletRequest.getSession().getId();
		Cookie sessCookie = new Cookie("JSESS", sessId);			
		httpServletResponse.addCookie(sessCookie); 
		
		System.out.println("-------------------------outside recomm new-------------------------");
		
		return new ModelAndView("newRecommBook");

		

	}

	
	  @RequestMapping(value = "/getRecommendBooks", method = RequestMethod.GET)
	  public ModelAndView getRecommendBooks(@RequestParam("dsessionId") String
	  dsessionId, ModelMap modelMap, HttpSession httpSession,
	  HttpServletResponse response, HttpServletRequest httpServletRequest) throws Exception
	  {
	  
	  RestTemplate template = new RestTemplate(); //get the string returned from API 
	  String fromapi=template.getForObject("http://10.150.232.32:5000/re",String.class); 
	  
	  System.out.println(fromapi);
	  
	  //split the string 
	  String[] parts= fromapi.split("="); 
	  String part1=parts[0]; String part2=parts[1]; // list of isbn numbers
	  
	  //split the isbn numbers 
	  parts=part2.split(","); part1=parts[0]; //for isbn1 
	  part2=parts[1];//for isbn2
	  
	  //for isbn1 
	  String[] isbnparts=part1.split(" "); 
	  String isbn1=isbnparts[0];
	  
	  //for isbn2 
	  isbnparts=part2.split("\""); String isbn2=isbnparts[0];
	  System.out.println(isbn1); System.out.println(isbn2);
	  
	  Book book1=bookfromisbn(isbn1); Book book2=bookfromisbn(isbn2);
	  
	  List<Book> recommendListlocal=new ArrayList<Book>();
	  recommendListlocal.add(book1); recommendListlocal.add(book2);
	  
	  this.setRecommendList(recommendListlocal); // set recommendList in jsp
	  modelMap.addAttribute("RecommendList", this.getRecommendList());
	  //setting SESSID in cookie
	  String sessId = httpServletRequest.getSession().getId();
	  Cookie sessCookie = new Cookie("JSESS", sessId);			
	  response.addCookie(sessCookie); 
	  
	  return new ModelAndView("newRecommBook");
	  
	  }
	 

	/*
	 * private List<Book> getRecommendsList(int categoryId, Object
	 * checkMeFromSession, int userId) throws SapeStoreException {
	 * 
	 * if (LOGGER.isDebugEnabled()) {
	 * LOGGER.debug("getRecommendsList method: START"); } List<Book>
	 * recommendList = null; try { try { recommendList =
	 * bookService.getRecommendList(categoryId, checkMeFromSession, userId); }
	 * catch (SapeStoreSystemException e) {
	 * LOGGER.error("getRecommendsList method: ERROR: " + e); }
	 * this.setRecommendList(recommendList); } catch (SapeStoreSystemException
	 * ex) { LOGGER.error("getRecommendsList method: ERROR: " + ex); return
	 * null; }
	 * 
	 * if (LOGGER.isDebugEnabled()) {
	 * LOGGER.debug("getRecommendsList method: END"); } return recommendList; }
	 */

	private Book bookfromisbn(String isbn) throws SapeStoreException {

		Book book = null;
		book = bookService.getisbnBook(isbn);

		return book;

	}

	public static String sendPostRequestold(String requestUrl, String payload) {

		StringBuffer jsonString = new StringBuffer();
		try {

			char[] JKS_PASSWORD = "password".toCharArray();
			char[] KEY_PASSWORD = "password".toCharArray();
			KeyStore ks = KeyStore.getInstance("JKS");
			ks.load(new FileInputStream("D:\\keystore.jks"), JKS_PASSWORD);
			// Key key = ks.getKey("selfsigned", password);

			KeyManagerFactory kmf = KeyManagerFactory
					.getInstance(KeyManagerFactory.getDefaultAlgorithm());
			kmf.init(ks, KEY_PASSWORD);
			final TrustManagerFactory tmf = TrustManagerFactory
					.getInstance(TrustManagerFactory.getDefaultAlgorithm());
			tmf.init(ks);

			/*
			 * Creates a socket factory for HttpsURLConnection using JKS
			 * contents
			 */
			final SSLContext sc = SSLContext.getInstance("TLS");
			sc.init(kmf.getKeyManagers(), tmf.getTrustManagers(),
					new java.security.SecureRandom());
			final SSLSocketFactory socketFactory = sc.getSocketFactory();
			HttpsURLConnection.setDefaultSSLSocketFactory(socketFactory);

			URL url = new URL(requestUrl);

			HttpsURLConnection connection = (HttpsURLConnection) url
					.openConnection();

			connection.setDoInput(true);
			connection.setDoOutput(true);
			connection.setRequestMethod("POST");
			connection.setRequestProperty("Accept", "application/json");
			connection.setRequestProperty("Content-Type",
					"application/json; charset=UTF-8");
			OutputStreamWriter writer = new OutputStreamWriter(
					connection.getOutputStream(), "UTF-8");
			writer.write(payload);
			writer.close();
			BufferedReader br = new BufferedReader(new InputStreamReader(
					connection.getInputStream()));

			String line;
			while ((line = br.readLine()) != null) {
				jsonString.append(line);
			}
			br.close();
			connection.disconnect();
		} catch (Exception e) {
			throw new RuntimeException(e.getMessage());
		}
		return jsonString.toString();
	}

	public static String sendPostRequest(String requestUrl, String payload) {

		StringBuffer jsonString = new StringBuffer();
		try {

			TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
				public java.security.cert.X509Certificate[] getAcceptedIssuers() {
					return null;
				}

				@Override
				public void checkClientTrusted(X509Certificate[] chain,
						String authType) throws CertificateException {
					// TODO Auto-generated method stub

				}

				@Override
				public void checkServerTrusted(X509Certificate[] chain,
						String authType) throws CertificateException {
					// TODO Auto-generated method stub

				}
			} };

			// Install the all-trusting trust manager
			SSLContext sc = SSLContext.getInstance("SSL");
			sc.init(null, trustAllCerts, new java.security.SecureRandom());
			HttpsURLConnection
					.setDefaultSSLSocketFactory(sc.getSocketFactory());

			HostnameVerifier allHostsValid = new HostnameVerifier() {

				@Override
				public boolean verify(String hostname, SSLSession session) {
					// TODO Auto-generated method stub
					return true;
				}
			};

			HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);

			URL url = new URL(requestUrl);

			HttpsURLConnection connection = (HttpsURLConnection) url
					.openConnection();

			connection.setDoInput(true);
			connection.setDoOutput(true);
			connection.setRequestMethod("POST");
			connection.setRequestProperty("Accept", "application/json");
			connection.setRequestProperty("Content-Type",
					"application/json; charset=UTF-8");
			connection.connect();
			OutputStreamWriter writer = new OutputStreamWriter(
					connection.getOutputStream(), "UTF-8");
			writer.write(payload);
			writer.close();
			BufferedReader br = new BufferedReader(new InputStreamReader(
					connection.getInputStream()));

			String line;
			while ((line = br.readLine()) != null) {
				jsonString.append(line);
			}
			br.close();
			connection.disconnect();
		} catch (Exception e) {
			throw new RuntimeException(e.getMessage());
		}
		return jsonString.toString();
	}

}
