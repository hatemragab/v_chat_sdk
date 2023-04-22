// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');

/** @type {{onBrokenLinks: string, baseUrl: string, presets: [string,Options][], organizationName: string, favicon: string, tagline: string, themeConfig: ThemeConfig & UserThemeConfig & AlgoliaThemeConfig, title: string, projectName: string, url: string, onBrokenMarkdownLinks: string, i18n: {defaultLocale: string, locales: string[]}}} */
const config = {
    title: 'V Chat SDK',
    tagline: 'V Chat is a cutting-edge chat API SaaS that leverages the power of Node.js and Socket.IO to provide a seamless real-time communication experience for its clients. This platform is designed to meet the needs of modern businesses that require instant communication solutions to engage their customers and teams efficiently.',
    url: 'https://hatemragab.github.io',
    baseUrl: '/v_chat_sdk/tree/master/documentations/vchat-v2/',

    favicon: 'img/favicon.ico',

    // GitHub pages deployment config.
    // If you aren't using GitHub pages, you don't need these.
    organizationName: 'hatemragab', // Usually your GitHub org/user name.
    projectName: 'VChatSdk-v2', // Usually your repo name.

    onBrokenLinks: 'throw',
    deploymentBranch:"gh-pages",
    onBrokenMarkdownLinks: 'warn',

    // Even if you don't use internalization, you can use this field to set useful
    // metadata like html lang. For example, if your site is Chinese, you may want
    // to replace "en" with "zh-Hans".
    i18n: {
        defaultLocale: 'en',
        locales: ['en'],
    },

    presets: [
        [
            'classic',
            /** @type {import('@docusaurus/preset-classic').Options} */
            ({
                docs: {
                    sidebarPath: require.resolve('./sidebars.js'),
                    // Please change this to your repo.
                    // Remove this to remove the "edit this page" links.
                    editUrl:
                        'https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/',
                },
                blog: {
                    showReadingTime: true,
                    // Please change this to your repo.
                    // Remove this to remove the "edit this page" links.
                    editUrl:
                        'https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/',
                },
                theme: {
                    customCss: require.resolve('./src/css/custom.css'),
                },
            }),
        ],
    ],

    themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
        ({
            // Replace with your project's social card
            image: 'img/docusaurus-social-card.jpg',
            navbar: {
                title: 'V Chat SDK v2',
                logo: {
                    alt: 'My Site Logo',
                    src: 'img/logo.svg',
                },
                items: [
                    {
                        type: 'doc',
                        docId: 'intro',
                        position: 'left',
                        label: 'Tutorial',
                    },

                    {
                        href: 'https://github.com/hatemragab/v_chat_sdk',
                        label: 'GitHub',
                        position: 'right',
                    },
                ],
            },
            footer: {
                style: 'dark',
                links: [
                    {
                        title: 'Docs',
                        items: [
                            {
                                label: 'Tutorial',
                                to: '/docs/intro',
                            },
                        ],
                    },
                    {
                        title: 'Community',
                        items: [
                            {
                                label: 'Stack Overflow',
                                href: 'https://stackoverflow.com/questions/tagged/v_chat_sdk',
                            },
                        ],
                    },
                    {
                        title: 'More',
                        items: [
                            {
                                label: 'GitHub',
                                href: 'https://github.com/hatemragab/v_chat_sdk',
                            },
                        ],
                    },
                ],
                copyright: `Copyright © ${new Date().getFullYear()} V CHAT SDK, Inc. `,
            },
            prism: {
                theme: lightCodeTheme,
                darkTheme: darkCodeTheme,
            },
        }),
};

module.exports = config;
