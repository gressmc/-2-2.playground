// Playground - noun: a place where people can play

import UIKit


//MARK: Таймер
func timeElapsedInSecondsWhenRunningCode(operation:()->(AnyObject)) -> Double {
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    return Double(timeElapsed)
}

//MARK: Сортировка

func quickSort<T:Comparable>(inout list:[T], start:Int, end:Int){
    if end - start < 2{
        return
    }
    var pivot = list[start + (end - start) / 2]
    
    var low = start
    var high = end - 1
    
    while low <= high {
        if list[low] < pivot{
            low++
            continue
        }
        if list[high] > pivot{
            high--
            continue
        }
        swap(&list[low], &list[high])
        
        low++
        high--
    }
    quickSort(&list, start, high + 1)
    quickSort(&list, high + 1, end)
}

//MARK: 1-Я попытка

func findK<T:Comparable>(inout list:[T], start:Int, end:Int, k:Int) -> T{
    
    //var pivot = list[start + (end - start) / 2]
    var pivot = list[k]
    
    var low = start
    var high = end - 1
    
    while low <= high {
        if list[low] < pivot{
            low++
            continue
        }
        if list[high] > pivot{
            high--
            continue
        }
        swap(&list[low], &list[high])
        
        low++
        high--
    }
    
    if(start <= k && k <= end - 1) {
        findK(&list, start, high + 1, k)
    }
    if( low <= k && k <= end - 1){
        findK(&list, high + 1, end, k)
    }
    return list[k]
}


//MARK: 2-Я попытка

func findK2<T:Comparable>(list:[T], k:Int) -> T{
    
    if list.count > 1 {
        
        var pivot = list[k]
        
        let smaller = filter(list, {$0 < pivot})
        let equal   = filter(list, {$0 == pivot})
        let greater = filter(list, {$0 > pivot})
        
        let smallerCount = smaller.count
        let equalCount   = equal.count
        
        
        if k < smallerCount{
            return findK2(smaller, k)
        } else if k < smallerCount + equalCount{
            return equal[0]
        }else{
            return findK2(greater, k - smallerCount - equalCount)
        }
    }
    return list[0]
}

//MARK: 3-Я попытка

func partition<T:Comparable>(subList:[T], pivot:T) -> [[T]]{
    return [filter(subList, {$0 < pivot}), filter(subList, {$0 == pivot}), filter(subList, {$0 > pivot})]
}

func quickSort<T:Comparable>(list:[T], k:Int) -> T{
    
    if list.count > 1 {
        
        let array = partition(list, list[k])
        
        if k < array[0].count{
            return quickSort(array[0], k)
        } else if k < array[0].count + array[1].count{
            return array[1][0]
        }else{
            return quickSort(array[2], k - array[0].count - array[1].count)
        }
    }
    return list[0]
}

func getMid<T:Comparable>(list:[T]) -> T {
    
    var subarray:[[T]] = []
    var n = 0
    
    while n < list.count {
        let arr = list.count - 10 < n ? Array(list[n..<list.count]) : Array(list[n..<n + 10])
        subarray.append(arr)
        n += 10
    }
    
    var midArray:[T] = []
    
    for item in subarray{
        midArray.append(quickSort(item, item.count/2))
    }
    
    return quickSort(midArray, midArray.count/2)
}

func findMid<T:Comparable>(list:[T], k:Int) -> T{
    
    let array = partition(list, getMid(list))
    
    if k < array[0].count{
        return findMid(array[0], k)
    } else if k < array[0].count + array[1].count{
        return array[1][0]
    } else {
        return findMid(array[2], k - (array[0].count + array[1].count))
    }
}


var tempArray = Array(count: 1000, repeatedValue: 0)
for idx in 0..<tempArray.count{
    tempArray[idx] = Int(arc4random_uniform(100))
}


var list = tempArray //[1,2,3,4,98,1,4,123,11,82, 83, 23, 13, 55]
var list1 = list
var list2 = list
var list3 = list


var t = timeElapsedInSecondsWhenRunningCode {
    quickSort(&list, 0, list.count)
    return 0
}

var t1 = timeElapsedInSecondsWhenRunningCode {
    let a = findK(&list1, 0, list1.count, 9)
    return 0
}

var t2 = timeElapsedInSecondsWhenRunningCode {
    findK2(list2, 9)
    return 0
}

var t3 = timeElapsedInSecondsWhenRunningCode {
    let a = quickSort(list3, 9)
    return 0
}
