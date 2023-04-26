# RISKPLOTS

This repository showcase the use of the `FRESA.CAD::RRplots()` function for the evaluation, and extraction of high risk thresholds for risk indexes of Poisson events.

The function was build to answer the following questions:

-   Are the probabities of the risk to future events in a given time interval calibrated?

    -   Do the probability of event matches the observed events?

    -   What is the Decision Curve Analysis between censored and non censored events?

    -   Do the observed events are occurring as predicted by the risk hazards?

-   What are the threshold for identifying the high risk subjects?

    -   What is the Hazard ratios between High risk subjects and the other population?

    -   What is the ROC curve and its significance?

-   Do the Kaplan-Meier plots are different between at risk stratified subjects?

    -   What is the level of significance?

If the risk are not calibrated FRESA.CAD provides the following functions to adjust the index probabilities to match the observed rate of events.

-   `FRESA.CAD::CoxRiskCalibration()`

-   `FRESA.CAD::CalibrationProbPoissonRisk()`

The first was designed to calibrate the probabilities of a COX model, the second was designed to calibrate the probabilities of risk to future event in a given time interval. Both functions will return the baseline hazard that best describe the data as well as the best time interval required to match the rate of observed events. Hence `CalibrationProbPoissonRisk()` can be applied to any methodology that returns either the prognostic indexes, hazards ratios or the probability of event in a time interval.

## Usage

``` {\usage}
  pinfo <- RRPlot(riskData=NULL,
    timetoEvent=NULL,
    riskTimeInterval=NULL,
    ExpectedPrevalence=NULL,
    atProb=c(0.90,0.80),
    atThr=NULL,
    title="",
    ysurvlim=c(0,1.0)
    )
```

### The Main Inputs

`-riskData`

The RRplots will assume that the input data (`riskData`) is a two column R data-frame. The first column will have the censoring information, i.e., {0: No event, 1: True event} The second column will have the probability of observing at least one event per time interval ($\Delta t$). Internally the function will assume that the Poisson distribution models the probability of observing k events. Hence:

$$
p(k>0)=1.0-e^{-\lambda},
$$

where $\lambda$ is the average number of events withing time interval, will estimate the probability of observing at least one event in the next time interval.

If the user models the risk by Cox modeling, then $\lambda$ is:

$$
\lambda= h_0e^{X \cdot \beta},
$$

where $h_0$ is the baseline hazard, $X$ are the risk factors, and $\beta$ the risk coefficients. Most of the times Cox models only return the prognosis index (PI), and PI=$X \cdot \beta$. The user must provide an estimation of the baseline hazard to estimate the probability of event for cox models. FRESA.CAD provides the function `ppoisGzero(index,h0)` to compute the probability of an event given the linear estimations returned by the Cox model.

`-timetoEvent`

If the user provides the `timetoEvent` vector with the times to event to the RRPlot function, then the expected number of events per time interval will be estimated by:

$$
\lambda=-log[1.0-p(k>0)],
$$

and

$$
\textrm{Expected Events}=t \lambda /\Delta t,
$$

where $t$ is the actual time to event and $\Delta t$ is the time interval. Hence the function will accumulate all average events per time interval to estimate the number of observed events withing the provided times to event.

`-riskTimeInterval`

To estimate the number of observed events in the spanned time provided by `timetoEvent` vector. All the observed times are divided by the user provided information in the `riskTimeInterval` input. i.e `riskTimeInterval` = $\Delta t$

### The Outputs

The `RRPlot()` will return the following six plots:

1.  Accumulated Probability vs Observed Events: Calibrated probabilities will follow the identity line.

    ![](images/paste-46CC928E.png){width="310"}

2.  Decision Curve Analysis: An indication of the power to make informed treatment benefit based on the returned probabilities.

    ![](images/paste-67156F85.png){width="318"}

3.  Relative Risk Analysis: An analysis of the effect of deciding a specific threshold of subjects at high risk.

    ![](images/paste-C47B6705.png){width="353"}

4.  Receiver Operative Characteristic (ROC): The behavior of the index as a prognosis of true future events vs. censored events (No events)

    ![](images/paste-BEE2BF81.png){width="377"}

5.  Time vs. Events: Shows if the provided probability is calibrated to the observed events. It requires that the user provides an accurate estimation of the time interval.

    ![](images/paste-A8932719.png){width="314"}

6.  Kaplan Meier: The standard Kaplan Meier plot of the user specified at risk groups.

    ![](images/paste-673C0FD4.png){width="318"}
