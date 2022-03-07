// const graph = cytoscape({
//     container: $('#cy'),
//     elements: [
//         {data: {id: 'a'}},
//         {data: {id: 'b'}},
//         {data: {id: 'ab', source: 'a', target: 'b'}}
//     ],
//     style: [
//         {
//             selector: 'node',
//             style: {
//                 'background-color': 'white',
//                 'label': 'data(id)'
//             }
//         },
//         {
//             selector: 'edge',
//             style: {
//                 'width': 3,
//                 'line-color': '#ccc',
//                 'target-arrow-color': '#ccc',
//                 'target-arrow-shape': 'triangle',
//                 'curve-style': 'bezier'
//             }
//         }
//     ],
//     layout: {
//         name: 'grid',
//         rows: 1
//     }
// });
// $("#ClickMe").click(function() {
//     $('#cy').toggle()
// });