# Домашнее задание к занятию "7.5. Основы golang"

С `golang` в рамках курса, мы будем работать не много, поэтому можно использовать любой IDE. 
Но рекомендуем ознакомиться с [GoLand](https://www.jetbrains.com/ru-ru/go/).  

## Задача 1. Установите golang.
```
root@ubuntu-test:/home/insane# go version
go version go1.13.8 linux/amd64
```
## Задача 2. Знакомство с gotour.
Ознакомился  

## Задача 3. Написание кода. 
Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода 
на своем компьютере, либо использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные 
у пользователя, а можно статически задать в коде.
    Для взаимодействия с пользователем можно использовать функцию `Scanf`:
 ```
root@ubuntu-test:/home/insane/devops-netology/Homework/7.5# cat 1.go
package main

import "fmt"

func main() {
    fmt.Print("Enter value in meters: ")
    var input float64
    var multiplier = 3.28084
    fmt.Scanf("%f", &input)

    output := input * multiplier

    fmt.Println("Result in foot:", output)
}
root@ubuntu-test:/home/insane/devops-netology/Homework/7.5# go run 1.go
Enter value in meters: 1
Result in foot: 3.28084

 ```
 
2. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
```
root@ubuntu-test:/home/insane/devops-netology/Homework/7.5# cat 2.go
package main
import "fmt"

func main() {

        x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}

        min := x[0]
        for _, v := range x {
                if v < min {
                        min = v
                }
        }

        fmt.Println(min)
}
root@ubuntu-test:/home/insane/devops-netology/Homework/7.5# go run 2.go
9

```
3. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.

```
root@ubuntu-test:/home/insane/devops-netology/Homework/7.5# cat 3.go
package main
import "fmt"

func main() {
        for x := 1; x <= 100; x++ {
                if x%3 == 0 {
                        fmt.Printf("%v;", x)
                }
        }
}
root@ubuntu-test:/home/insane/devops-netology/Homework/7.5# go run 3.go
3;6;9;12;15;18;21;24;27;30;33;36;39;42;45;48;51;54;57;60;63;66;69;72;75;78;81;84;87;90;93;96;99;

```

## Задача 4. Протестировать код (не обязательно).

Создайте тесты для функций из предыдущего задания. 

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

