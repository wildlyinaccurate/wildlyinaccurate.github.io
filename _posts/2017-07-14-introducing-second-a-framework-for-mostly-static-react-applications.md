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

During the [rebuild of the BBC News front page](/introducing-a-faster-bbc-news-front-page/), we decided that bundling the entire page as a React application and sending it to the browser was overkill for a page that is mostly static content. Given that only about 10% of the page components require JavaScript to function, we decided instead to build a standalone JavaScript bundle and manipulate the DOM by hand.

{% responsive_image path: assets/bbc-news-front-page-interactive-components.png alt: "A screenshot of the BBC News front page highlighting the components that require JavaScript" %}

As the front page project matured, we were finding that building the components' client-side JavaScript separately from their React views was becoming more difficult and error-prone. It was also confusing for newcomers—we use React but _not_ in the browser? Doesn't that defeat the purpose?

This experience led me to think about how we could run React (actually, [preact-compat](https://preactjs.com/guide/switching-to-preact)) in the browser for _just_ the interactive components. This would allow us to embed interactive components when we need to, without incurring the cost of bundling and rendering the entire page in the browser.

To cut a long story short, the solution I ended up with is a small framework called [Second](https://github.com/wildlyinaccurate/second).<!-- more -->

Second encapsulates several ideas that we learned while building the BBC News front page.

## Data-driven components with second-container

Inspired by Facebook's [Relay](https://facebook.github.io/relay/), second-container is a higher-order component that allows components to declare their data requirements. Unlike Relay which works with GraphQL, second-container works with regular HTTP requests out of the box, with support for custom data fetching built-in as well.

```jsx
class Result extends React.Component {
  render () {
    return (
      <li>
        {this.props.item.Text}
      </li>
    )
  }
}

class ResultList extends React.Component {
  render () {
    const topics = this.props.response.RelatedTopics
    const results = topics.filter(topic => topic.Text)

    return (
      <ul>
        {results.map(result => <Result item={result} />)}
      </ul>
    )
  }
}

const SearchResults = second.createContainer(ResultList, {
  data: props => ({
    response: {
      uri: `http://api.duckduckgo.com/?q=${props.query}&format=json`,
    }
  })
})
```
