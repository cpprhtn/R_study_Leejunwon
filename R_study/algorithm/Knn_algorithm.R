#KNN 알고리즘 연습

KNN은 데이터 분포의 근간에 대한 가정을 세우지 않아도 돼 
간단하면서도 강력한 알고리즘이기 때문에, 
특징들과 분류 결과 간의 연관성을 이해하기가 복잡하거나 어려운 경우에 사용이 가능하다.
불리하게 작용하는 면으로는 
데이터 처리에서 많은 양의 메모리를 필요로 한다는 점이다. 
거리 측정에 의존하고 추가적 프로세싱이 요구되는 결측치(Missing Value)는 
이 알고리즘의 또 다른 오버킬이다.


#1. 데이터 수집과 탐색
iris
summary(iris)
install.packages("ggvis")
library(ggvis)

iris %>% 
  ggvis(~Petal.Length, ~Petal.Width, fill = ~factor(Species)) %>%
  layer_points()

#2. 데이터 정규화
# 정규화 함수
min_max_normalizer <- function(x) {
  num <- x - min(x)
  denom <- max(x) - min(x)
  return (num/denom)
}
# Iris 데이터 세트 정규화
normalized_iris <- as.data.frame(lapply(iris[1:4], min_max_normalizer))
summary(normalized_iris)

#3. 트레이닝 데이터 세트, 테스트 데이터 세트 생성하기
# 데이터 구성 요소 확인
table(iris$Species)
# 랜덤을 위한 시드 값 세트
set.seed(1234)
# 트레이닝-테스트로 67%, 33%씩 나눈다.
random_samples <- sample(2, nrow(iris), replace=TRUE, prob=c(0.67,0.33))
# 트레이닝 데이터 세트
iris.training <- iris[random_samples == 1, 1:4]
# 트레이닝 라벨
iris.trainLabels <- iris[random_samples == 1, 5]
# 테스트 데이터 세트
iris.test <- iris[random_samples == 2, 1:4]
# 테스팅 라벨
iris.testLabels <- iris[random_samples == 2, 5]


#4. 데이터로부터 학습하기 / 모델 트레이닝 하기
#train: 트레이닝 데이터가 포함된 데이터 프레임
#test: 테스트 데이터가 포함된 데이터 프레임
#class: 클래스 라벨을 포함하는 벡터, Factor vector라고도 불린다.
#k: k근접 이웃의 k 값
library(class)
# k = 3에 대해 KNN실행
iris_model <- knn(train = iris.training, test = iris.test, 
                  cl = iris.trainLabels, k =3)
iris_model
#virginica중 한개의 versicolor 라벨(29번)만 제외 하고는 모두 정확함을 알 수 있다.

#5. 모델 평가
install.packages("gmodels")
library(gmodels)
CrossTable(x = iris.testLabels, y = iris_model, prop.chisq = FALSE)
