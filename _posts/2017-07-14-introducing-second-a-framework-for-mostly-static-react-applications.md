---
layout: post
title: 'Introducing Second: a framework for mostly-static React applications'
categories:
- Web Development
- React
tags:
- react
- preact
- static
- server-rendering
author: Joseph Wynn
published: true
---

During the [rebuild of the BBC News front page](/introducing-a-faster-bbc-news-front-page/), we decided that bundling the entire page as a React application and sending it to the browser was overkill for a page that is mostly static content. Given that only about 10% of the page components require JavaScript to function, we decided instead to build a standalone bundle that adds the functionality with vanilla JavaScript.

{% responsive_image path: assets/bbc-news-front-page-interactive-components.png alt: "A screenshot of the BBC News front page highlighting the components that require JavaScript" %}

As the front page project matured, we were finding that building the components' client-side JavaScript separately from their React views was becoming more difficult and error-prone. It was also confusing for newcomers—we use React but _not_ in the browser? Doesn't that defeat the purpose?

This experience led me to think about how we could run React (actually, [preact-compat](https://preactjs.com/guide/switching-to-preact)) in the browser for only the interactive components. This would allow us to easily build and embed interactive components when we need to, without incurring the cost of bundling and rendering the entire page in the browser.

After several months of experimentation, I ended up creating a small framework called [Second](https://github.com/wildlyinaccurate/second), which encapsulates several techniques that we learned while building the BBC News front page.<!-- more -->

## Data-driven components

Inspired by Facebook's [Relay](https://facebook.github.io/relay/), [second-container](https://github.com/wildlyinaccurate/second/tree/master/packages/second-container) is a higher-order component that allows components to declare their data requirements. Unlike Relay which works just with GraphQL, second-container works with regular HTTP requests out of the box, with support for custom data fetching built-in as well.

```jsx
const Result = ({ item }) => <li>{item.Text}</li>

const ResultList = ({ response }) => {
  const results = response.RelatedTopics.filter(topic => topic.Text)

  return <ul>
    {results.map(result => <Result item={result} />)}
  </ul>
}

const SearchResults = second.createContainer(ResultList, {
  data: props => ({
    response: {
      uri: `http://api.duckduckgo.com/?q=${props.query}&format=json`,
    }
  })
})
```

## Partial, opt-in browser rendering

[second-dehydrator](https://github.com/wildlyinaccurate/second/tree/master/packages/second-dehydrator) is a higher-order component that serialises (or _dehydrates_) a component's props and renders them into a `<script>` tag. The component can then be hydrated in the browser with those props, and rendered as a regular client-side React component.

```jsx
import { createDehydrator } from 'second-dehydrator'
import LargeComponent from './components/large-component'
import SmallComponent from './components/small-component'
import InteractiveComponent from './components/interactive-component'

const dehydrate = createDehydrator(React.createElement)
const DehydratedSmallComponent = dehydrate(SmallComponent)

const Page = (props) =>
    <LargeComponent>
      <SmallComponent {...props} />
      <InteractiveComponent {...props} />
      <SmallComponent {...props} />
    </LargeComponent>
```

To hydrate this component in the browser, second-dehydrator requires a component map and a function to call when the component is hydrated.

```js
import React from 'react'
import ReactDOM from 'react-dom'
import { hydrate } from 'second-dehydrator'

const componentMap = {
  InteractiveComponent: () => import(/* webpackMode: "eager" */ './components/interactive-component')
}

const renderComponent = (Component, props, containerElement) => {
  ReactDOM.render(
    React.createElement(Component, props),
    containerElement
  )
}

hydrate(renderComponent, componentMap)
```
