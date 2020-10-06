var expect  = require('chai').expect;
var request = require('request');
const { exec } = require("child_process");
const index = require('../index');

//https://buddy.works/guides/how-automate-nodejs-unit-tests-with-mocha-chai
describe('E2E',function() {
    it('Content tests', function (done) {
        request('http://localhost:3000/url', function (error, response, body) {
            expect(body).to.equal('["Jmeter","Locust","Gatling","k6"]');
            done();
        });
    });
});
//https://buddy.works/guides/how-automate-nodejs-unit-tests-with-mocha-chai
describe('Unit',function() {
    it('Dummy test', function (done) {
        true;
        done();
    });
});