<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page
	import="java.util.*,java.io.*,com.sapestore.hibernate.entity.BookCategory,com.sapestore.controller.ProductController"%>

<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!-->
<html class="no-js">
<!--<![endif]-->

<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>SapeStore-Home</title>
<meta name="description" content="">
<meta name="viewport" content="width=device-width">

<%@ include file="../header.jsp"%>

<!-- Place favicon.ico and apple-touch-icon.png in the root directory -->

<link rel="stylesheet" href="css/normalize.css">
<link rel="stylesheet" href="css/main.css">
<script src="js/vendor/modernizr-2.6.2.min.js"></script>
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js">
	
</script>
<script>
	$(document).ready(function() {
		$("#manageInv").css({
			position : 'relative',
			right : '24em',
			width : '8em',
			height : '30px',
			'background-color' : '#21addd',
			color : 'white',
		});

		$("#update").css({
			position : 'relative',
			width : '8em',
			height : '30px',
			top : '1px',
			'background-color' : '#21addd',
			color : 'white',
		});
	});

	function submitForm() {
		$(document)
				.ready(
						function() {

							var flag = true;
							$(".error").remove();
							var characterReg = /^[1-9]\d*$/;
							var nameReg = /^[a-zA-Z0-9 ]{1,100}$/;
							var isbnNameReg = /^[a-zA-Z0-9]{1,100}$/;
							var alphaReg = /^[.a-zA-Z ]{1,100}$/;
							//  var detailsReg=/^[-.,a-zA-Z0-9 ]{1,150}$/;

							var quantityVal = $("#quantity_id").val();
							var quantityValT = quantityVal.trim();
							if (!characterReg.test(quantityValT)) {
								$("#quantity_id")
										.after(
												'<span class="error"> 		Enter only numbers between 1-9(max 3 digits)</span>');
								flag = false;
							}

							var bookPrice = $("#bookPrice_id").val();
							var bookPriceT = bookPrice.trim();
							if (!characterReg.test(bookPriceT)) {
								$("#bookPrice_id")
										.after(
												'<span class="error"> 		Enter only numbers between 1-9(max 3 digits) </span>');
								flag = false;
							}

							var bookTitle = $("#bookTitle_id").val();
							var bookTitleT = bookTitle.trim();
							if (!nameReg.test(bookTitleT)) {
								$("#bookTitle_id")
										.after(
												'<span class="error"> 		Enter only alphanumerics(max 100 chars) </span>');
								flag = false;
							}

							var bookAuthor = $("#bookAuthor_id").val();
							var bookAuthorT = bookAuthor.trim();
							if (!alphaReg.test(bookAuthorT)) {
								$("#bookAuthor_id")
										.after(
												'<span class="error"> 	Enter only alphabets(max 100 chars)</span>');
								flag = false;
							}

							/* Added by Team Braavos */
							var categoryId = $("#categoryId").val();
							if (categoryId == "select") {
								$("#categoryId")
										.after(
												'<span class="error"> 		Select the Category.</span>');
								flag = false;
							}

							var rentPrice = $("#rentPrice_id").val();
							var rentPriceT = rentPrice.trim();
							if (!characterReg.test(rentPriceT)) {
								$("#rentPrice_id")
										.after(
												'<span class="error"> 		Enter only numbers between 1-9(max 3 digits) </span>');
								flag = false;
							}

							var bookShortDesc = $("#bookShortDesc_id").val();
							var bookShortDescT = bookShortDesc.trim();
							if (bookShortDescT.length == 0) {
								$("#bookShortDesc_id")
										.after(
												'<span class="error"> 		Description Cannot be blank"</span>');
								flag = false;
							}
							if (bookShortDescT.length > 250) {
								$("#bookShortDesc_id")
										.after(
												'<span class="error"> 		Maximum 250 characters."</span>');
								flag = false;
							}

							var bookDetailDesc = $("#bookDetailDesc_id").val();
							var bookDetailDescT = bookDetailDesc.trim();
							if (bookDetailDescT.length == 0) {
								$("#bookDetailDesc_id")
										.after(
												'<span class="error"> 	Description Cannot be blank"</span>');
								flag = false;
							}
							if (bookDetailDescT.length > 250) {
								$("#bookDetailDesc_id")
										.after(
												'<span class="error"> 	Maximum 250 characters."</span>');
								flag = false;
							}
							if (parseInt(rentPriceT) >= parseInt(bookPriceT)) {
								$("#rentPrice_iddiv").html(
												'<span class="error"> 		Rent Price should be lesser than Selling Price </span>');
								flag = false;
							}

							if (flag == true) {
								document.updateForm.submit();
							}
						});
	}
</script>
<script type="text/javascript">
	function dis_able() {
		var r = $("#rentAvailable_id").val().trim();
		if (r == "N") {
			document.getElementById("rentPrice_id").value = ${updateBooks.rentPrice};
			document.getElementById("rentPrice_id").disabled = true;

		} else {
			document.getElementById("rentPrice_id").disabled = false;
		}
	}
	function HandleBrowseClick() {
		var fileinput = document.getElementById("thumbImage");
		fileinput.click();
	}
	function Handlechange(event) {
		var fileinput = document.getElementById("thumbImage");
		var output = document.getElementById("imageupload")
		output.src = URL.createObjectURL(event.target.files[0]);
	    if (fileinput) {
			var startIndex = (fileinput.indexOf('\\') >= 0 ? fileinput
					.lastIndexOf('\\') : fileinput.lastIndexOf('/'));
			var filename = fileinput.substring(startIndex);
			if (filename.indexOf('\\') === 0 || filename.indexOf('/') === 0) {
				filename = filename.substring(1);
			}
			var textinput = document.getElementById("filename");
			textinput.value = filename.value;
		}
	}

	function HandleBrowseClickFullImage() {
		var fileinput = document.getElementById("fullImage");
		fileinput.click();
	}
	function HandlechangeFullImage(event) {
		var fileinput = document.getElementById("fullImage");
		var output = document.getElementById("fullimageupload")
		output.src = URL.createObjectURL(event.target.files[0]);
		 
		if (fileinput) {
			var startIndex = (fileinput.indexOf('\\') >= 0 ? fileinput
					.lastIndexOf('\\') : fileinput.lastIndexOf('/'));
			var filename = fileinput.substring(startIndex);
			if (filename.indexOf('\\') === 0 || filename.indexOf('/') === 0) {
				filename = filename.substring(1);
			}
			var textinput = document.getElementById("filenameFullImage");
			textinput.value = filename.value;
		}
		
	}

	function goBack() {
		window.history.back();
	}
	/* Added By Team Braavos */
	function editIsbn(){
		document.getElementById("editIsbn").innerHTML = "ISBN is not editable! You can delete this entry and add a new one!";
		}
</script>
</head>
<body onload="dis_able()">

	<c:choose>
		<c:when test="${sessionScope.username == null}">
			<a href="index.jsp"><h2>Access Denied. Click Here to Login</h2></a>
		</c:when>
		<c:when test="${sessionScope.username != null}">



			<!--[if lt IE 7]>
            <p class="chromeframe">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> or <a href="http://www.google.com/chromeframe/?redirect=true">activate Google Chrome Frame</a> to improve your experience.</p>
        <![endif]-->

			<!-- Add your site or application content here -->
			<div id="wrapper" class="homeAdmin">
				<!-- header starts-->
				<header>
					<div id="header">
						<a href="/SapeStore/manageInventory" title="SapeStore"
							class="logo"><img src="img/logo.jpg" width="231" height="109"
							alt="SapeStore"> </a>
						<ul class="topLinks hide">
							<li><input name="include_books" type="checkbox"
								value="include_books" checked> <a
								title="Add books from Partner Store" href="#">Include books
									from Partner Store</a></li>
							<li><a class='inline' href="#shoppingCart"><img
									src="img/icon_cart.jpg" width="15" height="12" alt="cart">
							</a></li>
							<li class="cartNum">0</li>
						</ul>
						<!-- in case of admin hide this and display another one -->

						<nav>
							<ul class="nav">
								<li class="active"><a href="/SapeStore/manageInventory">Manage
										Inventory</a></li>

								<li><a href="/SapeStore/manageOrders">Manage Orders</a></li>

								<li><a href="/SapeStore/adminReport">Manage Reports</a></li>

								<li><a href="/SapeStore/managePages">Manage Pages</a></li>

								<li><a href="/SapeStore/logout">Logout</a></li>
							</ul>
						</nav>
					</div>
				</header>
				<!-- header ends -->
				<section>
					<div id="mainContent" class="addAddress">
						<h2>Edit Book Details</h2>
						<div class="clearfix"></div>
						<form:form id="fid" name="updateForm"
							action="/SapeStore/updateInventory" enctype="multipart/form-data"
							method="post" modelAttribute="updateInv">
							<table>
								<fieldset>

									<div>
										<tr>
											<td class="tdLabel"><label for="thumbImage_id"
												class="label">Book Thumbnail Image<span
													class="required">*</span></label></td>
											<td><img alt="Book Thumbnail" width="81" height="112"
												src="${updateBooks.thumbPath}" id="imageupload"> <input type="button"
												value="Browse Image" id="fakeBrowse" name="fakeBrowse"
												onclick="HandleBrowseClick();" /> <label id="filename"
												style="font-size: 13px;"></label> <input type="file"
												id="thumbImage" name="thumbImage"
												value="${updateBooks.thumbPath}"
												accept="image/gif, image/jpeg, image/jpg, image/png, image/bmp"
												placeholder="Book Thumbnail Image" style="opacity: 0"
												onChange="Handlechange(event);" /> <input type="hidden"
												name="thumbImage" value="${updateBooks.thumbPath}" /></td>
										</tr>
									</div>
									<td class="tdLabel"><label for="fullImage" class="label">Book
											Detail Image<span class="required">*</span>
									</label></td>
									<td><img alt="Book Detail Image" width="81" height="112"
										src="${updateBooks.fullPath}" id="fullimageupload"> <input type="button"
										value="Browse Image" id="fakeBrowsefullImage"
										name="fakeBrowsefullImage"
										onclick="HandleBrowseClickFullImage();" /> <label
										id="filenameFullImage" style="font-size: 13px;"></label> <input
										type="file" id="fullImage" name="fullImage"
										value="${updateBooks.fullPath}"
										accept="image/gif, image/jpeg, image/jpg, image/png, image/bmp"
										placeholder="Book Detail Image" required="required"
										style="opacity: 0" onChange="HandlechangeFullImage(event);" /> <input
										type="hidden" name="fullImage" value="${updateBooks.fullPath}" />
									</td>
									</tr>
									</div>
									<div>
										<tr>
											<td class="tdLabel"><label for="bookTitle_id"
												class="label">Book Title<span class="required">*</span></label></td>
											<td><input type="text" name="bookTitle"
												value="${updateBooks.bookTitle}" id="bookTitle_id" /></td>
										</tr>
									</div>
									<div>
										<tr>
											<td class="tdLabel"><label for="bookAuthor_id"
												class="label">Book Author<span class="required">*</span></label></td>
											<td><input type="text" name="bookAuthor"
												value="${updateBooks.bookAuthor}" id="bookAuthor_id"
												placeholder="Book Author" /></td>
										</tr>
									</div>
									<div>
										<tr>
											<!-- Edited by Team Braavos -->
											<td class="tdLabel"><label for="isbn_id" class="label">ISBN<span
													class="required">*</span></label></td>
											<td><span style="position: relative;"
												onClick="editIsbn()"> <input type="text" name="isbn"
													disabled="disabled" value="${updateBooks.isbn}"
													id="isbn_id" /> <input type="hidden" name="isbn"
													value="${updateBooks.isbn}" id="isbn_id" /> <input
													type="hidden" id="oldIsbn" name="oldIsbn"
													value="${updateBooks.isbn}" />
											</span></td>
											<td><div style="color: red" id="editIsbn"></div>
										</tr>
									</div>
									<div>
										<tr>
											<!-- Edited by Team Braavos -->
											<td class="tdLabel"><label for="categoryName_id">Book
													Category<span class="required">*</span>
											</label></td>
											<td><select name="categoryId" id="categoryName">
													<c:forEach items="${categoryList}" var="current">
														<c:choose>
															<c:when
																test="${current.categoryId == currentBookCategoryId}">
																<option value="${current.categoryId}"
																	selected="selected">${updateBooks.categoryName}</option>
															</c:when>
															<c:when
																test="${current.categoryId != currentBookCategoryId}">
																<option value="${current.categoryId}">${current.categoryName}</option>
															</c:when>
														</c:choose>
													</c:forEach>
											</select></td>
										</tr>
									</div>
									<div>
										<tr>
											<!-- Edited by Team Braavos -->
											<td class="tdLabel"><label for="rentAvailable_id"
												class="label">Available for</label></td>
											<td><input type="hidden"
												value="${updateBooks.rentPrice}" name="rentPrice_id_false"
												id="rentPrice_id_false" placeholder="Rent Price" /> <select
												name="rentAvailable" id="rentAvailable_id"
												onchange="dis_able()">
													<c:choose>
														<c:when test="${currentRentAvailability=='Y' }">
															<option value="Y" selected="selected"">Rent</option>
															<option value="N">Purchase</option>
														</c:when>
														<c:when test="${currentRentAvailability=='N' }">
															<option value="Y">Rent</option>
															<option value="N" selected="selected">Purchase</option>
														</c:when>
													</c:choose>
											</select></td>
										</tr>
									</div>
									<div>
										<tr>
											<td class="tdLabel"><label for="bookPrice_id"
												class="label">Selling Price (In $)<span
													class="required">*</span></label></td>
											<td><input type="text" name="bookPrice"
												value="${updateBooks.bookPrice}" id="bookPrice_id"
												placeholder="Book Price (In $)" /></td>
										</tr>
									</div>
									<div>
										<tr>
											<td class="tdLabel"><label for="rentPrice_id"
												class="label">Rent Price (In $)<span
													class="required">*</span></label></td>
											<td><input type="text" name="rentPrice"
												value="${updateBooks.rentPrice}" id="rentPrice_id"
												placeholder="Rent Price" />
												<div id="rentPrice_iddiv"></div></td>
										</tr>
									</div>
									<div>
										<tr>
											<td class="tdLabel"><label for="quantity_id"
												class="label">Number of Books<span class="required">*</span></label></td>
											<td><input type="text" name="quantity"
												value="${updateBooks.quantity}" id="quantity_id"
												placeholder="11" /></td>
										</tr>
									</div>
									<div>
										<tr>
											<td class="tdLabel"><label for="publisherName_id"
												class="label">Publisher Name<span class="required">*</span></label></td>
											<td><input type="text" name="publisherName"
												value="${updateBooks.publisherName}" id="publisherName_id"
												placeholder="Publisher Name" /></td>
										</tr>
									</div>
									<div>
										<tr>
											<td class="tdLabel"><label for="bookShortDesc_id"
												class="label">Short Description<span
													class="required">*</span></label></td>
											<td><textarea name="bookShortDesc" cols="25" rows="3"
													id="bookShortDesc_id" placeholder="Short Description">${updateBooks.bookShortDesc}
								</textarea></td>
										</tr>
									</div>
									<div>
										<tr>
											<td class="tdLabel"><label for="bookDetailDesc_id"
												class="label">DetailedS Description</label></td>
											<td><textarea name="bookDetailDesc" cols="25" rows="6"
													id="bookDetailDesc_id" placeholder="Detail Description ">${updateBooks.bookShortDesc}
								</textarea></td>
										</tr>
									</div>
								</fieldset>
								<br>

								<div id="cancel" style="width: 42em;">
									<tr>
										<td colspan="3">
											<div align="right">
												<input id="update" name="update" type="button"
													style="right: 25em;" value="Update Store"
													onclick="submitForm()">
												<button type="button" id="manageInv" name="manageInv"
													value="Submit" onclick="goBack()">Cancel</button>
											</div>
										</td>
									</tr>
								</div>
							</table>
						</form:form>
					</div>
				</section>

				<div class="clearfix"></div>
				<footer>
					<div id="footer">

						<div>
							Powered by <img src="img/sapient_nitro.jpg" width="78"
								height="14" alt="sapient nitro">
						</div>
					</div>
			</div>
			</footer>
			</div>
			<script
				src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
			<script>
		window.jQuery
				|| document
						.write('<script src="js/vendor/jquery-1.9.1.min.js"><\/script>')
	</script>
			<script src="js/plugins.js"></script>
			<script src="js/main.js"></script>


		</c:when>
	</c:choose>
	
	<%@ include file="../footer.jsp"%>
	
</body>
</html>