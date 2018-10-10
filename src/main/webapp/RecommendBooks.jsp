

<div class="recommendations">
	<h2>Recommended Books</h2>
	<div class="clearfix"></div>
	<form name="recommendationForm" action="addToShoppingCart" method="GET">
		<ul>
			<c:forEach items="${recommendList}" var="current">
				<li><a id="clickBook"
					href="/SapeStore/bookDetailsController?isbn=${current.isbn}"
					title="${current.bookTitle}"
					onclick="dataLayer.push({'bookprice' : '${current.bookPrice}',
										    'bookcategory' : '-2',
										    'bookcategoryName' : 'Recommended Books',
										    'booktitle' : '${current.bookTitle}'});">
						<img src="${current.bookFullImage}" width="131" height="180" /> <span
						id="product_name">${current.bookTitle}</span>
						<p>${current.bookAuthor}</p>
				</a>
					<figure>
						<c:choose>
							<c:when test="${current.averageRating == null}">
								<img src="img/ratings-0.jpg" width="98" height="14"
									alt="ratings" />
							</c:when>
							<c:otherwise>
								<img src="img/ratings-${current.averageRating}.jpg" width="98"
									height="14" alt="ratings" />
							</c:otherwise>
						</c:choose>
					</figure>
					<p class="price">$${current.bookPrice}</p> <c:choose>
						<c:when test="${not empty userId}">
							<a id="addToCart"
								href="/SapeStore/addToShoppingCart?categoryId=${current.categoryId}&categoryName=${categoryName}&checkMe=${checkMe}&isbn=${current.isbn}&type=Purchase"
								title="Add To Cart" class="addCart"
								onclick="dataLayer.push({'bookprice' : '${current.bookPrice}',
										    'bookcategory' : '-2',
										    'bookcategoryName' : 'Recommended Books',
										    'booktitle' : '${current.bookTitle}'});">
								<img src="img/add_cart.jpg" width="15" height="13"
								alt="add to cart" />
							</a>
						</c:when>
						<c:otherwise>
							<script type="text/javascript">
								function alertIt() {
									alert("Please login to be able to use the cart.");
								}
							</script>
							<a href="#login" title="Add To Cart" class="addCart inline"
								id="addToCart"
								onclick="dataLayer.push({'bookprice' : '${current.bookPrice}',
										    'bookcategory' : '-2',
										    'bookcategoryName' : 'Recommended Books',
										    'booktitle' : '${current.bookTitle}'});"><img
								src="img/add_cart.jpg" width="15" height="13" alt="add to cart" /></a>
						</c:otherwise>
					</c:choose></li>
			</c:forEach>
		</ul>
	</form>
</div>

