import React from 'react';
import clsx from 'clsx';
import styles from './styles.module.css';

const FeatureList = [
  {
    title: 'Easy to Use',
    Svg: require('@site/static/img/undraw_docusaurus_mountain.svg').default,
    description: (
      <>
        VChatsdk was designed from the ground up to be easily installed and
        used to get your chat system up and running quickly.
      </>
    ),
  },
  {
    title: 'Focus on Your product',
    Svg: require('@site/static/img/undraw_docusaurus_tree.svg').default,
    description: (
      <>
          V Chat is a chat API SaaS that is designed to help businesses focus on their core products and services while providing them with powerful communication capabilities. With V Chat's Node.js and Socket.IO based server and Flutter-based client-side app,
          businesses can easily integrate real-time chat functionality into their products without having to worry about developing and maintaining their own chat infrastructure.
      </>
    ),
  },
  {
    title: 'About chat',
    Svg: require('@site/static/img/undraw_docusaurus_react.svg').default,
    description: (
      <>
          Overall, V Chat is a powerful and reliable chat API SaaS that combines the latest technologies to provide seamless real-time communication capabilities for businesses of all sizes.
          Whether you are looking to enhance your customer engagement or streamline your team communication,
          V Chat is the ideal solution that can help you achieve your goals.
      </>
    ),
  },
];

function Feature({Svg, title, description}) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <h3>{title}</h3>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
