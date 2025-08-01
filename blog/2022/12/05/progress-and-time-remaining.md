---
title: Progress and time remaining
pubDate: 2022-12-05T00:00:00.000Z
author: rsdoiel@sdf.org (R. S. Doiel)
keywords:
  - programming
  - golang
  - log info
copyrightYear: 2022
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >

  I often find myself logging output when I'm developing tools.  This is
  typically the case where I am iterating over data and transforming it.
  Overtime I've come to realize I really want a few specific pieces of
  information for non-error logging (e.g. `-verbose` which monitors progress as
  well as errors).


  - percentage completed

  - estimated time allocated (i.e. time remaining)


  To do that I need three pieces of information.


  1. the count of the current iteration(e.g. `i`)

  2. the total number of iterations required (e.g. `tot`)

  3. The time just before I started iterating(e.g. `t0`)


  The values for `i` and `tot` let me compute the percent completed. The percent
  completed is trivial `(i/tot) * 100.0`. Note on the first pass (i.e. `i == 0`)
  you can skip the percentage calculation.


  ...
dateCreated: '2022-11-05'
dateModified: '2025-07-22'
datePublished: '2022-11-05'
---

# Progress and time remaining

By R. S. Doiel, 2022-11-05

I often find myself logging output when I'm developing tools.  This is typically the case where I am iterating over data and transforming it. Overtime I've come to realize I really want a few specific pieces of information for non-error logging (e.g. `-verbose` which monitors progress as well as errors).

- percentage completed
- estimated time allocated (i.e. time remaining)

To do that I need three pieces of information.

1. the count of the current iteration(e.g. `i`)
2. the total number of iterations required (e.g. `tot`)
3. The time just before I started iterating(e.g. `t0`)

The values for `i` and `tot` let me compute the percent completed. The percent completed is trivial `(i/tot) * 100.0`. Note on the first pass (i.e. `i == 0`) you can skip the percentage calculation.


```golang
import (
	"time"
	"fmt"
)

// Show progress with amount of time running
func progress(t0 time.Time, i int, tot int) string {
    if i == 0 {
        return ""
    }
	percent := (float64(i) / float64(tot)) * 100.0
	t1 := time.Now()
	// NOTE: Truncating the duration to seconds
	return fmt.Sprintf("%.2f%% %v", percent, t1.Sub(t0).Truncate(time.Second))
}
```

Here's how you might use it.

```golang
	tot := len(ids)
	t0 := time.Now()
	for i, id := range ids {
		// ... processing stuff here ... and display progress every 1000 records
		if (i % 1000) == 0 {
			log.Printf("%s records processed", progress(t0, i, tot))
		}
	}
```

An improvement on this is to include an time remaining. I need to calculated the estimated time allocation (i.e. ETA). I know `t0` so I can estimate that with this formula `estimated time allocation = (((current running time since t0)/ the number of items processed) * total number of items)`[^1]. ETA adjusted for time running gives us time remaining[^2]. The first pass of the function progress has a trivial optimization since we don't have enough delta t0 to compute an estimate. Calls after that are computed using our formula.

[^1]: In code `(rt/i)*tot` is estimated time allocation

[^2]: Estimated Time Remaining, in code `((rt/i)*tot) - rt`

```golang
func progress(t0 time.Time, i int, tot int) string {
	if i == 0 {
		return "0.00 ETR Unknown"
	}
	// percent completed
	percent := (float64(i) / float64(tot)) * 100.0
	// running time
    rt := time.Now().Sub(t0)
    // estimated time allocation - running time = time remaining
    eta := time.Duration((float64(rt)/float64(i)*float64(tot)) - float64(rt))
    return fmt.Sprintf("%.2f%% ETR %v", percent, eta.Truncate(time.Second))
}
```