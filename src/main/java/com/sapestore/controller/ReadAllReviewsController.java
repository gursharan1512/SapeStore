
package com.sapestore.controller;

import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.sapestore.common.SapeStoreLogger;
import com.sapestore.dao.BookDetailsDao;
import com.sapestore.exception.SapeStoreException;
import com.sapestore.exception.SapeStoreSystemException;
import com.sapestore.hibernate.entity.Book;
import com.sapestore.hibernate.entity.BookCategory;
import com.sapestore.hibernate.entity.BookRatingComments;
import com.sapestore.service.BookService;
import com.sapestore.service.ReviewService;

// TODO: Auto-generated Javadoc
/**
 * The Class ReadAllReviewsController.
 */
@Controller
@SessionAttributes(value = { "book", "bookRatingCommentList", "bookVo" })
public class ReadAllReviewsController {

  /** The book list. */
  private List<Book> bookList;

  /** The cat list. */
  private List<BookCategory> catList;

  /** The category name. */
  private String categoryName;

  /** The check me. */
  private boolean checkMe;

  /** The book rating comment list. */
  private List<BookRatingComments> bookRatingCommentList;

  /** The book service. */
  @Autowired
  private BookService bookService;

  /** The book details. */
  @Autowired
  BookDetailsDao bookDetails;

  /** The review service. */
  @Autowired
  private ReviewService reviewService;

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
   *          the new book service
   */
  public void setBookService(BookService bookService) {
    this.bookService = bookService;
  }

  /**
   * Checks if is check me.
   *
   * @return true, if is check me
   */
  public boolean isCheckMe() {
    return checkMe;
  }

  /**
   * Sets the check me.
   *
   * @param checkMe
   *          the new check me
   */
  public void setCheckMe(boolean checkMe) {
    this.checkMe = checkMe;
  }

  /**
   * Gets the book list.
   *
   * @return the book list
   */
  public List<Book> getBookList() {
    return bookList;
  }

  /**
   * Sets the book list.
   *
   * @param bookList
   *          the new book list
   */
  public void setBookList(List<Book> bookList) {
    this.bookList = bookList;
  }

  /**
   * Gets the cat list.
   *
   * @return the cat list
   */
  public List<BookCategory> getCatList() {
    return catList;
  }

  /**
   * Sets the cat list.
   *
   * @param catList
   *          the new cat list
   */
  public void setCatList(List<BookCategory> catList) {
    this.catList = catList;
  }

  /**
   * Gets the category name.
   *
   * @return the category name
   */
  public String getCategoryName() {
    return categoryName;
  }

  /**
   * Sets the category name.
   *
   * @param categoryName
   *          the new category name
   */
  public void setCategoryName(String categoryName) {
    this.categoryName = categoryName;
  }

  /**
   * Gets the book rating comment list.
   *
   * @return the book rating comment list
   */
  public List<BookRatingComments> getBookRatingCommentList() {
    return bookRatingCommentList;
  }

  /**
   * Sets the book rating comment list.
   *
   * @param bookRatingCommentList
   *          the new book rating comment list
   */
  public void setBookRatingCommentList(List<BookRatingComments> bookRatingCommentList) {
    this.bookRatingCommentList = bookRatingCommentList;
  }

  /**
   * Gets the book.
   *
   * @return the book
   */
  public BookDetailsDao getBook() {
    return bookDetails;
  }

  /**
   * Sets the book.
   *
   * @param bookDetails
   *          the new book
   */
  public void setBook(BookDetailsDao bookDetails) {
    this.bookDetails = bookDetails;
  }

  /** The Constant LOGGER. */
  private static final SapeStoreLogger LOGGER = SapeStoreLogger.getLogger(
      ReadAllReviewsController.class.getName());

  /**
   * This is a controller class for review lists page. CHANGE LOG
   *
   * @author aaga47
   * @version 1.0
   * @param isbn
   *          the isbn
   * @param modelMap
   *          the model map
   * @param session
   *          the session
   * @return the string
   * @throws SapeStoreException
   *           the sape store exception
   */

  @RequestMapping(value = "/readAllReviews", method = RequestMethod.GET)
  public String beforeLogin(@RequestParam("isbn") String isbn, ModelMap modelMap,
      HttpSession session, HttpServletResponse response, 
      HttpServletRequest httpServletRequest) throws SapeStoreException {

    LOGGER.debug(" ReadAllReviewsController.bookDetails method: START ");
    this.setCatList(getCategoryList());
    Book book = bookDetails.getBookDetails(isbn);
    session.setAttribute("bookVo", book);
    modelMap.addAttribute("book", book);
    modelMap.addAttribute("catList", this.getCatList());
    modelMap.addAttribute("categoryName", book.getCategoryName());
    List<BookRatingComments> bookReviewList = null;
    bookReviewList = getReviewsListByIsbn(isbn);
    this.setBookRatingCommentList(bookReviewList);
    modelMap.addAttribute("bookRatingCommentList", bookReviewList);
    //setting SESSID in cookie
	String sessId = httpServletRequest.getSession().getId();
	Cookie sessCookie = new Cookie("JSESS", sessId);			
	response.addCookie(sessCookie); 
    LOGGER.debug("ReadAllReviewsController.bookDetails method: END ");
    LOGGER.error(book.getBookDetailDescription());

    return "ReadAllReviews";
  }

  /**
   * This is agetReviewsListByIsbn method for for landing book details and
   * reviews page. CHANGE LOG
   *
   * @author aaga47
   * @version 1.0
   * @param isbn
   *          the isbn
   * @return the reviews list by isbn
   * @throws SapeStoreException
   *           the sape store exception
   */

  public List<BookRatingComments> getReviewsListByIsbn(String isbn) throws SapeStoreException {
    LOGGER.debug("getReviewsListByIsbn method: START");
    List<BookRatingComments> bookReviewList = null;
    bookReviewList = reviewService.getReviewlist(isbn);
    LOGGER.debug("getReviewsListByIsbn method: END");
    return bookReviewList;
  }

  /**
   * Gets the category list.
   *
   * @return the category list
   * @throws SapeStoreException
   *           the sape store exception
   */
  private List<BookCategory> getCategoryList() throws SapeStoreException {
    if (LOGGER.isDebugEnabled()) {
      LOGGER.debug("getCategoryList method: START");
    }

    List<BookCategory> bookCategoryList = null;

    try {
      bookCategoryList = bookService.getCategoryList();

    } catch (SapeStoreSystemException ex) {
      LOGGER.error("getCategoryList method: ERROR: " + ex);
      return null;
    }

    if (LOGGER.isDebugEnabled()) {
      LOGGER.debug("getCategoryList method: END");
    }
    return bookCategoryList;
  }
}
