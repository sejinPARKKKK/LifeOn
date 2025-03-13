document.addEventListener("DOMContentLoaded", () => {
    console.log("DOM이 로드되었습니다.")

    // 메인 배너 왼쪽 슬라이더 기능
    const mainBannerLeft = document.querySelector(".main-banner-left")
    const sliderContainer = document.querySelector(".slider-container")
    const slides = document.querySelectorAll(".slide")
    const indicators = document.querySelectorAll(".indicator")

    console.log("슬라이더 컨테이너:", sliderContainer ? "찾음" : "못찾음")
    console.log("슬라이드 개수:", slides.length)
    console.log("인디케이터 개수:", indicators.length)

    let currentSlide = 0
    let slideInterval

    // 슬라이드 표시 함수 - 현재 CSS 구조에 맞게 수정
    function showSlide(index) {
        console.log("슬라이드 표시:", index)

        // 모든 슬라이드 비활성화
        slides.forEach((slide) => {
            slide.classList.remove("active")
        })

        // 선택한 슬라이드만 활성화
        if (slides[index]) {
            slides[index].classList.add("active")
        }

        // 인디케이터 업데이트
        indicators.forEach((indicator, i) => {
            indicator.classList.toggle("active", i === index)
        })

        currentSlide = index
    }

    // 다음 슬라이드로 이동
    function nextSlide() {
        currentSlide = (currentSlide + 1) % slides.length
        showSlide(currentSlide)
    }

    // 이전 슬라이드로 이동
    function prevSlide() {
        currentSlide = (currentSlide - 1 + slides.length) % slides.length
        showSlide(currentSlide)
    }

    // 자동 슬라이드 시작
    function startSlideShow() {
        if (slideInterval) {
            clearInterval(slideInterval)
        }
        slideInterval = setInterval(nextSlide, 5000)
    }

    // 자동 슬라이드 정지
    function stopSlideShow() {
        clearInterval(slideInterval)
    }

    // 인디케이터 클릭 이벤트
    indicators.forEach((indicator, index) => {
        indicator.addEventListener("click", () => {
            console.log("인디케이터 클릭:", index)
            showSlide(index)
            stopSlideShow()
            startSlideShow()
        })
    })

    // 슬라이더에 마우스 오버/아웃 이벤트
    if (sliderContainer) {
        sliderContainer.addEventListener("mouseenter", stopSlideShow)
        sliderContainer.addEventListener("mouseleave", startSlideShow)
    } else if (mainBannerLeft) {
        mainBannerLeft.addEventListener("mouseenter", stopSlideShow)
        mainBannerLeft.addEventListener("mouseleave", startSlideShow)
    }

    // 초기 슬라이드 설정 및 자동 슬라이드 시작
    if (slides.length > 0) {
        console.log("초기 슬라이드 설정")
        // 첫 번째 슬라이드를 기본적으로 활성화
        slides[0].classList.add("active")
        startSlideShow()
    }

    // 오른쪽 작은 배너 캐러셀 기능
    const mainBannerRight = document.querySelector(".main-banner-right")
    const carouselImages = mainBannerRight.querySelectorAll(".image-container-right") // 클래스명 변경
    const carouselLeftBtn = document.querySelector(".carousel-control.left")
    const carouselRightBtn = document.querySelector(".carousel-control.right")
    const pageIndicator = document.querySelector(".page-indicator")

    console.log("캐러셀 이미지 개수:", carouselImages.length)

    let currentPage = 0
    const totalPages = carouselImages.length
    let carouselInterval

    // 캐러셀 이미지 초기 설정 - 첫 번째만 표시하고 나머지는 숨김
    function initCarousel() {
        if (carouselImages.length === 0) return

        carouselImages.forEach((image, index) => {
            if (index === 0) {
                image.style.display = "flex"
            } else {
                image.style.display = "none"
            }
        })

        updatePageIndicator()
    }

    // 페이지 인디케이터 업데이트
    function updatePageIndicator() {
        if (pageIndicator && totalPages > 0) {
            pageIndicator.textContent = `${currentPage + 1}/${totalPages} 페이지`
        }
    }

    // 캐러셀 이미지 표시
    function showCarouselImage(index) {
        console.log("캐러셀 이미지 표시:", index)

        // 모든 이미지 숨기기
        carouselImages.forEach((image) => {
            image.style.display = "none"
        })

        // 선택한 이미지만 표시
        if (carouselImages[index]) {
            carouselImages[index].style.display = "flex"
        }

        currentPage = index
        updatePageIndicator()
    }

    // 다음 캐러셀 이미지로 이동
    function nextCarouselImage() {
        const nextIndex = (currentPage + 1) % totalPages
        showCarouselImage(nextIndex)
    }

    // 이전 캐러셀 이미지로 이동
    function prevCarouselImage() {
        const prevIndex = (currentPage - 1 + totalPages) % totalPages
        showCarouselImage(prevIndex)
    }

    // 자동 캐러셀 시작
    function startCarouselShow() {
        if (carouselInterval) {
            clearInterval(carouselInterval)
        }
        carouselInterval = setInterval(nextCarouselImage, 10000) // 10초마다 자동 전환
    }

    // 자동 캐러셀 정지
    function stopCarouselShow() {
        clearInterval(carouselInterval)
    }

    // 캐러셀 컨트롤 버튼 이벤트
    if (carouselLeftBtn) {
        carouselLeftBtn.addEventListener("click", () => {
            prevCarouselImage()
            stopCarouselShow()
            startCarouselShow() // 타이머 재시작
        })
    }

    if (carouselRightBtn) {
        carouselRightBtn.addEventListener("click", () => {
            nextCarouselImage()
            stopCarouselShow()
            startCarouselShow() // 타이머 재시작
        })
    }

    // 캐러셀에 마우스 오버/아웃 이벤트
    if (mainBannerRight) {
        mainBannerRight.addEventListener("mouseenter", stopCarouselShow)
        mainBannerRight.addEventListener("mouseleave", startCarouselShow)
    }

    // 캐러셀 초기화 및 자동 시작
    if (carouselImages.length > 0) {
        console.log("캐러셀 초기화")
        initCarousel()
        startCarouselShow()
    }
})

